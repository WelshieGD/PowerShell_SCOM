#=================================================================================
#  SCOM Script to find all Management packs that have classes and count instances discovered
#  From https://kevinholman.com/2020/07/14/how-to-find-unused-management-packs-in-scom/
#  Author: Kevin Holman
#  v1.0
#=================================================================================
param([Parameter(Mandatory)][string]$MSName,[string]$OutputFolder)


# Manual Testing section - put stuff here for manually testing script - typically parameters:
#=================================================================================
# $MSName = "scom2.opsmgr.net"
# $OutputFolder = "C:\temp"
#=================================================================================


# Constants section - modify stuff here:
#=================================================================================
# Assign script name variable for use in event logging.  
# ScriptName should be the same as the ID of the module that the script is contained in
$ScriptName = "SCOM.FindUnusedMPs.ps1"
$EventID = "911"
#=================================================================================


# Starting Script section - All scripts get this
#=================================================================================
# Gather the start time of the script
$StartTime = Get-Date
#Set variable to be used in logging events
$whoami = whoami
# Load MOMScript API
$momapi = New-Object -comObject MOM.ScriptAPI
#Log script event that we are starting task
$momapi.LogScriptEvent($ScriptName,$EventID,0,"`nScript is starting. `nRunning as ($whoami).")
#=================================================================================


# Connect to SCOM Management Group Section
#=================================================================================
# I have found this to be the most reliable method to load SCOM modules for scripts running on Management Servers
# Clear any previous errors
$Error.Clear()
# Import the OperationsManager module and connect to the management group
$SCOMPowerShellKey = "HKLM:\SOFTWARE\Microsoft\System Center Operations Manager\12\Setup\Powershell\V2"
$SCOMModulePath = Join-Path (Get-ItemProperty $SCOMPowerShellKey).InstallDirectory "OperationsManager"
Import-module $SCOMModulePath
TRY
{
  New-DefaultManagementGroupConnection -managementServerName $MSName
}
CATCH
{
  IF ($Error) 
  { 
    $momapi.LogScriptEvent($ScriptName,$EventID,1,"`n FATAL ERROR: Unable to load OperationsManager module or unable to connect to Management Server. `n Terminating script. `n Error is: ($Error).")
    EXIT
  }
}
#=================================================================================


# Begin MAIN script section
#=================================================================================
$AllMPs = Get-SCOMManagementPack | Sort-Object

# Add filtered MP's here that you dont want examined such as default SCOM MP's override MP's etc.
$FilteredMPs = $AllMPs | where {($_.name -notlike "System.*") `
    -and ($_.name -ne "Microsoft.SystemCenter.2007") `
    -and ($_.name -ne "Microsoft.SystemCenter.ACS.Internal") `
    -and ($_.name -notlike "Microsoft.SystemCenter.Advisor*") `
    -and ($_.name -notlike "Microsoft.SystemCenter.Apm.*") `
    -and ($_.name -notlike "Microsoft.SystemCenter.ApplicationMonitoring.*") `
    -and ($_.name -notlike "Microsoft.SystemCenter.ClientMonitoring.*") `
    -and ($_.name -notlike "Microsoft.SystemCenter.Data*") `
    -and ($_.name -ne "Microsoft.SystemCenter.GTM.Summary.Dashboard.Template") `
    -and ($_.name -ne "Microsoft.SystemCenter.Image.Library") `
    -and ($_.name -ne "Microsoft.SystemCenter.InstanceGroup.Library") `
    -and ($_.name -notlike "Microsoft.SystemCenter.Internal*") `
    -and ($_.name -ne "Microsoft.SystemCenter.Library") `
    -and ($_.name -notlike "Microsoft.SystemCenter.Network*") `
    -and ($_.name -notlike "Microsoft.SystemCenter.Notifications*") `
    -and ($_.name -ne "Microsoft.SystemCenter.NTService.Library") `
    -and ($_.name -notlike "Microsoft.SystemCenter.O365*") `
    -and ($_.name -notlike "Microsoft.SystemCenter.OperationsManager.*") `
    -and ($_.name -ne "Microsoft.SystemCenter.ProcessMonitoring.Library") `
    -and ($_.name -ne "Microsoft.SystemCenter.Reports.Deployment") `
    -and ($_.name -ne "Microsoft.SystemCenter.RuleTemplates") `
    -and ($_.name -ne "Microsoft.SystemCenter.SecureReferenceOverride") `
    -and ($_.name -ne "Microsoft.SystemCenter.ServiceDesigner.Library") `
    -and ($_.name -ne "Microsoft.SystemCenter.SyntheticTransactions.Library") `
    -and ($_.name -ne "Microsoft.SystemCenter.TaskTemplates") `
    -and ($_.name -notlike "Microsoft.SystemCenter.Visualization.*") `
    -and ($_.name -notlike "Microsoft.SystemCenter.WebApplication*") `
    -and ($_.name -ne "Microsoft.SystemCenter.WorkflowFoundation.Library") `
    -and ($_.name -ne "Microsoft.SystemCenter.WSManagement.Library") `
    -and ($_.name -notlike "Microsoft.Unix.*") `
    -and ($_.name -ne "Microsoft.Windows.Image.Library") `
    -and ($_.name -ne "Microsoft.Windows.Library") `
    -and ($_.name -ne "Microsoft.Windows.Server.Library") `
    -and ($_.name -ne "Microsoft.Windows.Server.NetworkDiscovery") `
    -and ($_.name -ne "Microsoft.Windows.Server.Reports") `
    -and ($_.name -ne "ODR") `
    }

IF (!($OutputFolder))
{
  $OutputFolder = "C:\temp"
  IF (!(Test-Path $OutputFolder))
  {
    New-Item -ItemType Directory -Path $OutputFolder
  }
}
ELSE
{
  $OutputFolder = $OutputFolder.TrimEnd("\")
}

$MG = Get-SCOMManagementGroup
[string]$MGName = $MG.Name

$MPArr = @()
$MPClassSum = @()
$MPSum = @()

FOREACH ($mp in $FilteredMPs)
{
  [string]$MPName = $mp.Name 
  Write-Host "Examining MP:"$MPName
  $MParr = @()
  [int]$MPInstancesCount = 0
  #Get all non-singleton Classes
  $Classes = $mp | Get-SCOMClass | Where {($_.Singleton -eq $false) -and ($_.Abstract -eq $false)}

  [int]$ClassCount = $Classes.Count
  IF ($ClassCount -ge 1)
  {
    Write-Host "Found Class count:"$ClassCount
    #This MP has class definitions
    FOREACH ($Class in $Classes)
    {
      $ClassArr = @()
      [string]$ClassName = $Class.Name
      Write-Host "Examining Class:"$ClassName
      #This MP has a class that is not a singleton and will be included in the output
      $MPObj = ""
      $Instances = $Class | Get-SCOMClassInstance
      [int]$InstancesCount = $Instances.Count
      Write-Host "Found Instance count:"$InstancesCount
      #Create a PowerShell Object to assign properties
      $MPObj = New-Object PSObject
      $MPObj | Add-Member -type NoteProperty -Name 'MPName' -Value $MPName
      $MPObj | Add-Member -type NoteProperty -Name 'ClassName' -Value $ClassName
      $MPObj | Add-Member -type NoteProperty -Name 'Instances' -Value $InstancesCount
      $ClassArr += $MPObj
      $MPArr += $ClassArr
      $MPInstancesCount = ($MPArr.Instances | Measure-Object -Sum).Sum
    }
    Write-Host "Found MP Total Instance count:"$MPInstancesCount
    #Create a PowerShell Object to assign properties
    $MPSumObj = New-Object PSObject
    $MPSumObj | Add-Member -type NoteProperty -Name 'MPName' -Value $MPName
    $MPSumObj | Add-Member -type NoteProperty -Name 'Instances' -Value $MPInstancesCount
    $MPSum += $MPSumObj 
  }
  ELSE
  {
    Write-Host "No classes found"
  }
  $MPClassSum += $MPArr
}

#Sort 
$MPClassSum = $MPClassSum | Sort-Object -Property @{Expression = "MPName"; Descending = $False}, @{Expression = "Instances"; Descending = $True}
$MPSum = $MPSum | Sort-Object -Property @{Expression = "Instances"; Descending = $True},@{Expression = "MPName"; Descending = $False} 

Write-Host "Exporting to CSV....."
$MPSum | Export-Csv $OutputFolder\MPInstanceCount_$MGName.csv -NoTypeInformation
$MPClassSum | Export-Csv $OutputFolder\MPClassInstanceCount_$MGName.csv -NoTypeInformation
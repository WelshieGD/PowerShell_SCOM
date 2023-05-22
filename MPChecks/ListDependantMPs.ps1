<# 
From https://sc.scomurr.com/scom-2012-getting-management-pack-dependents/

#>

# Replace with the MP you are looking to find the dependents of
$MPToFind = $AllManagementPacks | where{$_.Name -eq ‘Microsoft.Windows.Server.ClusterSharedVolumeMonitoring’}

$DependentMPs = @()

# Iterate through and identify the MPs that have the specified MP listed as a reference
foreach($MP in $AllManagementPacks) {
$Dependent = $false
$MP.References | foreach{
if($_.Value.Name -eq $MPToFind.Name) { $Dependent = $true }
}
if($Dependent -eq $true) {
$DependentMPs+= $MP
}
}

#List out of the dependent MPs
$DependentMPs | ft Name

This will dump a list of the MPs that are dependent on the MP in question to the screen.  

Import-Module OperationsManager
New-SCOMManagementGroupConnection -ComputerName SCOMMS

$Class = Get-SCOMClass -Name "Microsoft.Windows.Computer"

# $Instances = Get-SCOMClassInstance -Class $Class 
# $Instances
# Note that the above will show greyed out Computers in the state that they were last in when they greyed out. So COmputers that are greyed out will potentially list healthy. 

# $Instances = Get-SCOMClassInstance -Class $Class | Where {$_.IsAvailable -eq $False} | Select DisplayName, IsAvailable, AvailabilityLastModified

# $Instances = Get-SCOMClassInstance -Class $Class | Select DisplayName, IsAvailable, AvailabilityLastModified | sort IsAvailable -descending

$Instances = Get-SCOMClassInstance -Class $Class | Select DisplayName, IsAvailable, AvailabilityLastModified, InMaintenanceMode, ``[Microsoft.Windows.Computer`].IPAddress | sort IsAvailable -descending


$instances

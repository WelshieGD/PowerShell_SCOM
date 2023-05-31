
# Get a list of all Management Packs
Get-SCOMManagementPack | Select *

# Select Properties
Get-SCOMManagementPack | Select Name, DisplayName, Description, Version, Sealed, TimeCreated, TimeModified, Id 

# Specific Manaement Pack
Get-SCOMManagementPack | Where {$_.Name -eq "System.Library"}

$MPName = "System.Library"
Get-SCOMManagementPack | Where {$_.Name -eq $MPName}

# Wild Card = All SQL Management Packs
$MPName = "SQL"
Get-SCOMManagementPack | Where {$_.Name -like "*$MPName*"}


# References for a specific Management Pack
$MPName = "Microsoft.SQLServer.Windows.Views"
Get-SCOMManagementPack | Where {$_.Name -eq $MPName} | Select -ExpandProperty References

#  Just name of referenced MP
$MPName = "Microsoft.SQLServer.Windows.Views"
$References = Get-SCOMManagementPack | Where {$_.Name -eq $MPName} | Select -ExpandProperty References
$References | Select Name




# Export Management Packs
Get-SCOMManagementPack | where {$_.Sealed -eq $True } | Export-SCOMManagementpack -Path "C:\Management Packs\Sealed"
Get-SCOMManagementPack | where {$_.Sealed -eq $False } | Export-SCOMManagementpack -Path "C:\Management Packs\UnSealed"

# Remove MP
MPName = "SQL server 2016"
Get-SCOMManagementPack | where {$_.displayname -match "SQL server 2016"} | Remove-SCOMManagementPack

<# 
Can also be done in SQL although I can't find a way to extract references

SELECT Name AS 'ManagementPackID',
 FriendlyName,
 DisplayName,
 Version,
 Sealed,
 LastModified,
 TimeCreated 
FROM ManagementPackView
WHERE LanguageCode = 'ENU' 
OR LanguageCode IS NULL
ORDER BY DisplayName
#>

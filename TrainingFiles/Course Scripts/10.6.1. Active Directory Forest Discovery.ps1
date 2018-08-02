$SiteCode = "001"
 
Set-CMDiscoveryMethod -ActiveDirectoryForestDiscovery -EnableActiveDirectorySiteBoundaryCreation $True -Enabled $True -EnableSubnetBoundaryCreation $True -SiteCode $SiteCode
Invoke-CMForestDiscovery -SiteCode $SiteCode

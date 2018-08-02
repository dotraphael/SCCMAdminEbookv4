$SiteCode = "001"
 
$domainName = "LDAP://DC=$($env:USERDNSDOMAIN.Split(".") -join ",DC=")"
Set-CMDiscoveryMethod -ActiveDirectoryUserDiscovery -AddActiveDirectoryContainer "$($domainname)" -DeltaDiscoveryIntervalMinutes 30 -Enabled $True -EnableDeltaDiscovery $True -SiteCode $SiteCode -AddAdditionalAttribute @("physicalDeliveryOfficeName") -recursive
Invoke-CMUserDiscovery -SiteCode $SiteCode

$SiteCode = "001"
 
$domainName = "LDAP://DC=$($env:USERDNSDOMAIN.Split(".") -join ",DC=")"
Set-CMDiscoveryMethod -ActiveDirectorySystemDiscovery -AddActiveDirectoryContainer "$($domainName)" -Enabled $True -EnableDeltaDiscovery $True -EnableFilteringExpiredLogon $True -EnableFilteringExpiredPassword $True -SiteCode $SiteCode -TimeSinceLastLogonDays 90 -TimeSinceLastPasswordUpdateDays 90 -AddAdditionalAttribute @("pwdLastSet") -Recursive
Invoke-CMSystemDiscovery -SiteCode $SiteCode

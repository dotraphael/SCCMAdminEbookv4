$SiteCode = "001"
 
$domainName = "LDAP://DC=$($env:USERDNSDOMAIN.Split(".") -join ",DC=")"
$discovery = New-CMADGroupDiscoveryScope -LdapLocation "$($domainName)" -Name "$($domainName)" -SiteCode $SiteCode -RecursiveSearch $true
Set-CMDiscoveryMethod -ActiveDirectoryGroupDiscovery -AddGroupDiscoveryScope ($discovery) -Enabled $True -SiteCode $SiteCode -EnableDeltaDiscovery $true
Invoke-CMGroupDiscovery -SiteCode $SiteCode

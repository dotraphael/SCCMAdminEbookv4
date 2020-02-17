$SiteCode = "001"
$AppName = "Firefox 49"
$CollName = "Users OU"

New-CMApplicationDeployment -Name "$AppName" -CollectionName "$CollName" -UpdateSupersedence $True

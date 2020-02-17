$AppName = "Google Chrome"
$ColName = "Workstation OU"
New-CMApplicationDeployment -CollectionName "$ColName" -Name "$AppName" -DeployAction Install -DeployPurpose Available

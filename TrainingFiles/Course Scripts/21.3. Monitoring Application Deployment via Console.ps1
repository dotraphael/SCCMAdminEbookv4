$AppName = "Google Chrome"
$ColName = "Workstation OU"

Get-CMDeployment -CollectionName "$ColName" -SoftwareName "$AppName" | Invoke-CMDeploymentSummarization
Start-Sleep 10
Get-CMDeployment -CollectionName "$ColName" -SoftwareName "$AppName" | select ApplicationName, CollectionName, NumberErrors, NumberInProgress, NumberOther, NumberSuccess, NumberTargeted, NumberUnknown

Get-CMApplication -Name $AppName | Get-CMApplicationDeploymentStatus | Get-CMDeploymentStatusDetails | select MachineName, ComplianceState, InstalledState, StatusType

$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"

$KB = "KB3173424"
$SupGroup = "Windows 8x Critical Updates"
$DepGroup = "Windows 8x Critical Updates"
$DepPath = "\\SRV0001\WSUSDownloadContent\W8xCriticalUpdates"
$ColName = "Windows 8 Workstations"
New-CMSoftwareUpdateGroup -Name "$SupGroup"
Start-Sleep 5

$UpdateList = Get-CMSoftwareUpdate -Name "*$($KB)*" -fast | Where-Object {$_.LocalizedDisplayName -like "*x64*"}
Set-CMSoftwareUpdateGroup -Name "$SupGroup" -AddSoftwareUpdate $UpdateList
Start-Sleep 5
(Get-CMSoftwareUpdate -UpdateGroupName "$SupGroup" -fast).LocalizedDisplayName 
Start-Sleep 5

New-CMSoftwareUpdateDeploymentPackage -Name "$DepGroup" -Path "$DepPath"
start-sleep 10
Save-CMSoftwareUpdate -DeploymentPackageName "$DepGroup" -SoftwareUpdateGroupName "$SupGroup"
Start-Sleep 60
Start-CMContentDistribution -DeploymentPackageName "$DepGroup" -DistributionPointGroupName "Training Lab"
Start-Sleep 10
New-CMSoftwareUpdateDeployment -CollectionName "$ColName" -SoftwareUpdateGroupName "$SupGroup" -AcceptEula -DeploymentType Available -DownloadFromMicrosoftUpdate $True -VerbosityLevel AllMessages

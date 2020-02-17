$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"

$KB = "KB4530684" #update from december/2019
$SupGroup = "Windows 10x Security Updates"
$DepGroup = "Windows 10x Security Updates"
$DepPath = "\\SRV0001\WSUSDownloadContent\W10xSecurityUpdates"
$ColName = "Windows 10 Workstations"
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

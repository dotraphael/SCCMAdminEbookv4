$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"
$ADRName = "ADR-Definition Updates" 

$pkg = New-CMSoftwareUpdateDeploymentPackage -Name "$ADRName" -Path \\SRV0001\wsusDownloadContent\ADR-DefUpdates
start-sleep 5
Start-CMContentDistribution -DeploymentPackageId $pkg.PackageID -DistributionPointGroupName "Training Lab"
start-sleep 5
New-CMSoftwareUpdateAutoDeploymentRule -CollectionName "All Desktop and Server Clients" -Name "$ADRName" -AddToExistingSoftwareUpdateGroup $True -AllowSoftwareInstallationOutsideMaintenanceWindow $True -AvailableTime 1 -AvailableTimeUnit Hours -DeadlineImmediately $True -DeploymentPackageName "$ADRName" -DeployWithoutLicense $True -DownloadFromInternet $True -DownloadFromMicrosoftUpdate $True -EnabledAfterCreate $True -GenerateSuccessAlert $True -RunType RunTheRuleAfterAnySoftwareUpdatePointSynchronization -UserNotification HideAll -UseUtc $False -VerboseLevel AllMessages -UpdateClassification @('Critical Updates', 'Definition Updates') -Language @("English") -LanguageSelection @("English") -Product @('System Center Endpoint Protection', 'Windows Defender')
start-sleep 5
Invoke-CMSoftwareUpdateAutoDeploymentRule -Name "$ADRName"

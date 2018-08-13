. c:\TrainingFiles\Scripts\Add-CMDeploymentTypeGlobalCondition.ps1

$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

$ParentAppName = "App-V Client 5.0"
$AppName = "Robocopy"
$DTName = "Robocopy - Microsoft Application Virtualization 5"

New-CMApplication -Name "$AppName"

Add-CMAppv5XDeploymentType -ApplicationName "$AppName" -ContentLocation "\\srv0001\trainingfiles\Source\Robocopy App-V5\Robocopy.appv" -DeploymentTypeName "$DTName" -FastNetworkDeploymentMode DownloadContentForStreaming

Get-CMDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" | New-CMDeploymentTypeDependencyGroup -GroupName "App-V Client" | Add-CMDeploymentTypeDependency -DeploymentTypeDependency (Get-CMDeploymentType -ApplicationName "$ParentAppName") -IsAutoInstall $true

Add-CMDeploymentTypeGlobalCondition -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition OperatingSystem -Operator OneOf -Value "Windows/All_x64_Windows_8.1_Client;Windows/All_x64_Windows_10_and_higher_Clients"

Start-CMContentDistribution -ApplicationName "$AppName" -DistributionPointGroupName "Training Lab"
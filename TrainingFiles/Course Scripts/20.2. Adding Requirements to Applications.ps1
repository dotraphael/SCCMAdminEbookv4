. c:\TrainingFiles\Scripts\Add-CMDeploymentTypeGlobalCondition.ps1

$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"
$AppName = "Google Chrome"
$DTName = "Google Chrome - Windows Installer (*.msi file)"

Add-CMDeploymentTypeGlobalCondition -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition OperatingSystem -Operator OneOf -Value "Windows/All_x64_Windows_10_and_higher_Clients"

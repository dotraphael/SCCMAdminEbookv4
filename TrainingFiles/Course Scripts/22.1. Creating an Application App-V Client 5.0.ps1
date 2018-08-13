. c:\TrainingFiles\Scripts\Add-CMDeploymentTypeGlobalCondition.ps1
. c:\TrainingFiles\Scripts\Set-CMDetectionRule.ps1

$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"

$AppName = "App-V Client 5.0"
$DTName = "App-V client for Windows 8 x64"
$MSIProductCode = "{6313DBA3-0CA9-4CD8-93B3-373534146B7B}"

New-CMApplication -Name "$AppName"
Add-CMScriptDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -InstallCommand '"appv_client_setup.exe" /q /ACCEPTEULA' -ProductCode "$MSIProductCode" -ContentLocation "\\srv0001\trainingfiles\source\App-V5 Client" -LogonRequirementType WhereOrNotUserLoggedOn -UninstallCommand '"appv_client_setup.exe" /UNINSTALL /q'
Get-CMDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" | Set-CMDeploymentType -MsiOrScriptInstaller -InstallationBehaviorType InstallForSystem
Add-CMDeploymentTypeGlobalCondition -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition OperatingSystem -Operator OneOf -Value "Windows/All_x64_Windows_8.1_Client;Windows/All_x64_Windows_10_and_higher_Clients"

#using SetCMDetectionRule instead of Set-CMScriptDeploymentType with New-CMDetectionClauseRegistryKeyValue because it does not alow "or" with multiple checks
#$rule = New-CMDetectionClauseRegistryKeyValue -ExpectedValue 5.2 -ExpressionOperator BeginsWith -Hive LocalMachine -KeyName "SOFTWARE\Microsoft\AppV\Client" -PropertyType String -Value -ValueName Version -Is64Bit
#Set-CMScriptDeploymentType  -ApplicationName $AppName -DeploymentTypeName $DTName -AddDetectionClause $rule
Set-CMDetectionRule -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -CreateRegistryValidation -RegistryKey "SOFTWARE\Microsoft\AppV\Client" -RegistryKeyValue "Version" -RegistryKeyValidationValue "5.2" -CreateMSIValidation -MSIProductCode "$MSIProductCode"

. c:\TrainingFiles\Scripts\Add-CMDeploymentTypeGlobalCondition.ps1

$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"

$AppName = "Firefox 40"
$DTName = "Firefox 40 Installation for Windows 8.1 and 10"

New-CMApplication -Name "$AppName"
$DetectionRule = New-CMDetectionClauseFile -ExpectedValue "40.0" -ExpressionOperator GreaterEquals -FileName "firefox.exe" -Path "%ProgramFiles%\Mozilla Firefox" -PropertyType Version -Value
Add-CMScriptDeploymentType -AddDetectionClause $DetectionRule -ApplicationName $AppName -DeploymentTypeName $DTName -InstallCommand '"Firefox Setup 40.0.exe" -ms' -ContentLocation '\\srv0001\TrainingFiles\Source\Firefox 40' -InstallationBehaviorType InstallForSystem -LogonRequirementType WhereOrNotUserLoggedOn -UninstallCommand '"C:\Program Files (x86)\Mozilla Firefox\uninstall\helper.exe" -ms'
Add-CMDeploymentTypeGlobalCondition -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition OperatingSystem -Operator OneOf -Value "Windows/All_x64_Windows_10_and_higher_Clients;Windows/All_x64_Windows_8.1_Client"

Start-CMContentDistribution -ApplicationName "$AppName" -DistributionPointGroupName "Training Lab"
New-CMApplicationDeployment -CollectionName "Users OU" -Name "$AppName"

$AppName = "Firefox 49"
$DTName = "Firefox 49 Installation for Windows 8.1 and 10"

New-CMApplication -Name "$AppName"
$DetectionRule = New-CMDetectionClauseFile -ExpectedValue "49.0" -ExpressionOperator GreaterEquals -FileName "firefox.exe" -Path "%ProgramFiles%\Mozilla Firefox" -PropertyType Version -Value
Add-CMScriptDeploymentType -AddDetectionClause $DetectionRule -ApplicationName $AppName -DeploymentTypeName $DTName -InstallCommand '"Firefox Setup 49.0.1.exe" -ms' -ContentLocation '\\srv0001\TrainingFiles\Source\Firefox 49' -InstallationBehaviorType InstallForSystem -LogonRequirementType WhereOrNotUserLoggedOn -UninstallCommand '"C:\Program Files (x86)\Mozilla Firefox\uninstall\helper.exe" -ms'
Add-CMDeploymentTypeGlobalCondition -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition OperatingSystem -Operator OneOf -Value "Windows/All_x64_Windows_10_and_higher_Clients;Windows/All_x64_Windows_8.1_Client"

Get-CMDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" | Set-CMDeploymentType -MsiOrScriptInstaller -InstallationBehaviorType InstallForSystem
Start-CMContentDistribution -ApplicationName "$AppName" -DistributionPointGroupName "Training Lab"

$AppName = "Java8"
$DTName = "Java8 for Windows 10"

New-CMApplication -Name "$AppName"
$DetectionRule = New-CMDetectionClauseFile -ExpectedValue "8.0.1010" -ExpressionOperator GreaterEquals -FileName "java.exe" -Path "%ProgramFiles%\Java\jre1.8.0_101\bin" -PropertyType Version -Value
Add-CMScriptDeploymentType -AddDetectionClause $DetectionRule -ApplicationName $AppName -DeploymentTypeName $DTName -InstallCommand '"Java8.exe" /s' -ContentLocation '\\srv0001\TrainingFiles\Source\Java8' -InstallationBehaviorType InstallForSystem -LogonRequirementType WhereOrNotUserLoggedOn
Add-CMDeploymentTypeGlobalCondition -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition OperatingSystem -Operator OneOf -Value "Windows/All_x64_Windows_10_and_higher_Clients"

Start-CMContentDistribution -ApplicationName "$AppName" -DistributionPointGroupName "Training Lab"

$AppName = "Acrobat Reader XI"
$DTName = "Acrobat Reader XI for Windows 10"

New-CMApplication -Name "$AppName"
Add-CMScriptDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -InstallCommand '"AdbeRdr11010_en_US.exe" /msi EULA_ACCEPT=YES REMOVE_PREVIOUS=YES /qn' -ProductCode "{AC76BA86-7AD7-1033-7B44-AB0000000001}" -ContentLocation "\\srv0001\trainingfiles\Source\AdobeXI" -InstallationBehaviorType InstallForSystem  -LogonRequirementType WhereOrNotUserLoggedOn
Add-CMDeploymentTypeGlobalCondition -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition OperatingSystem -Operator OneOf -Value "Windows/All_x64_Windows_10_and_higher_Clients;Windows/All_x64_Windows_8.1_Client"

Start-CMContentDistribution -ApplicationName "$AppName" -DistributionPointGroupName "Training Lab"

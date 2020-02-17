$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"

$AppName = "App-V Client 5.0"
$DTName = "App-V client for Windows 8 x64"
$MSIProductCode = "{6313DBA3-0CA9-4CD8-93B3-373534146B7B}"

$OS_GC = Get-CMGlobalCondition -Name 'Operating System' | Where-Object { $_.ModelName -eq 'GLOBAL/OperatingSystem' }
$OSx64_GC = $OS_GC | New-CMRequirementRuleOperatingSystemValue -PlatformString Windows/All_x64_Windows_8.1_Client, Windows/All_x64_Windows_10_and_higher_Clients -RuleOperator OneOf


$App = New-CMApplication -Name "$AppName"
$DT = Add-CMScriptDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -InstallCommand '"appv_client_setup.exe" /q /ACCEPTEULA' -ProductCode "$MSIProductCode" -ContentLocation "\\srv0001\trainingfiles\source\App-V5 Client" -LogonRequirementType WhereOrNotUserLoggedOn -UninstallCommand '"appv_client_setup.exe" /UNINSTALL /q'
$DT | Set-CMDeploymentType -MsiOrScriptInstaller -InstallationBehaviorType InstallForSystem -ClearRequirements -AddRequirement $OSx64_GC
$DT | Set-CMScriptDeploymentType  -AddDetectionClause $rule -DetectionClauseConnector @{"LogicalName"=$rule.Setting.LogicalName;"Connector"="OR"}

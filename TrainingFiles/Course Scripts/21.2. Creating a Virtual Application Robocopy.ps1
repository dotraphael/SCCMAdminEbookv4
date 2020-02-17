$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

$ParentAppName = "App-V Client 5.0"
$AppName = "Robocopy"
$DTName = "Robocopy - Microsoft Application Virtualization 5"

$OS_GC = Get-CMGlobalCondition -Name 'Operating System' | Where-Object { $_.ModelName -eq 'GLOBAL/OperatingSystem' }
$OSx64_GC = $OS_GC | New-CMRequirementRuleOperatingSystemValue -PlatformString Windows/All_x64_Windows_8.1_Client, Windows/All_x64_Windows_10_and_higher_Clients -RuleOperator OneOf


$App = New-CMApplication -Name "$AppName"
$DT = Add-CMAppv5XDeploymentType -ApplicationName "$AppName" -ContentLocation "\\srv0001\trainingfiles\Source\Robocopy App-V5\Robocopy.appv" -DeploymentTypeName "$DTName" -FastNetworkDeploymentMode DownloadContentForStreaming
$DT | New-CMDeploymentTypeDependencyGroup -GroupName "App-V Client" | Add-CMDeploymentTypeDependency -DeploymentTypeDependency (Get-CMDeploymentType -ApplicationName "$ParentAppName") -IsAutoInstall $true
$DT | Set-CMDeploymentType -ClearRequirements -AddRequirement $OSx64_GC

Start-CMContentDistribution -ApplicationName "$AppName" -DistributionPointGroupName "Training Lab"
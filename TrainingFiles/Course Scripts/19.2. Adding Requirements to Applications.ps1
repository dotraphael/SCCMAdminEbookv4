$AppName = "Google Chrome"
$DTName = "Google Chrome - Windows Installer (*.msi file)"

$OS_GC = Get-CMGlobalCondition -Name 'Operating System' | Where-Object { $_.ModelName -eq 'GLOBAL/OperatingSystem' }
$OSx64_GC = $OS_GC | New-CMRequirementRuleOperatingSystemValue -PlatformString Windows/All_x64_Windows_10_and_higher_Clients -RuleOperator OneOf
$App = Get-CMApplication | where-object {$_.LocalizedDisplayName -eq $AppName}
$DT = Get-CMDeploymentType -InputObject $App | Where-Object {$_.LocalizedDisplayName -eq $DTName}
$DT | Set-CMDeploymentType -MsiOrScriptInstaller -ClearRequirements -AddRequirement $OSx64_GC

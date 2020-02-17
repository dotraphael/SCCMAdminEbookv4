$GC = Get-CMGlobalCondition -Name "Computer Model"
$GC_Model = $GC | New-CMRequirementRuleCommonValue -RuleOperator IsEquals -Value1 'SVD11225CYB'

$AppName = "Java8"
$DTName = "Java8 for Windows 10"
$DT = Get-CMDeploymentType -ApplicationName $AppName -DeploymentTypeName $DTName
$DT | Set-CMDeploymentType -AddRequirement $GC_Model

$SiteCode = "001"

$Deployments = Get-CMDeployment -CollectionName "Windows 10 Workstations" | where {$_.SoftwareName -eq "Workstation Baseline"} 
$ID = $Deployments.AssignmentID
$Deployments | Invoke-CMDeploymentSummarization
start-sleep 30

#Non-Compliant
gwmi -namespace root\sms\site_$SiteCode -class "SMS_DCMDeploymentNonCompliantAssetDetails" -Filter "AssignmentID = $($ID) and (RuleSubState = 0)" | select AssetName, RuleName, RuleStateDisplay

#Compliant
gwmi -namespace root\sms\site_$SiteCode -class "SMS_DCMDeploymentCompliantAssetDetails" -Filter "AssignmentID = $($ID)" | select AssetName

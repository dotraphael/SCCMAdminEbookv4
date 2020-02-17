$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

$Deployments = Get-CMDeployment -CollectionName "Windows 10 Workstations" | where {$_.SoftwareName -eq "Workstation Baseline"} 

$CollUpdate = New-CMSchedule -Start "01/01/2015 9:00 PM" -DayOfWeek Saturday -RecurCount 1
$Collection = New-CMDeviceCollection -Name "Compliant Machines" -LimitingCollectionName "Windows 10 Workstations" -RefreshSchedule $CollUpdate -RefreshType Both
Add-CMDeviceCollectionQueryMembershipRule -CollectionId $Collection.CollectionID -RuleName "Compliant Machines"  -QueryExpression "select * from  SMS_R_System inner join SMS_G_System_DCMDeploymentState on SMS_G_System_DCMDeploymentState.ResourceID = SMS_R_System.ResourceId WHERE BaselineID = '$($Deployments.ModelName)' AND CollectionID = '$($Deployments.CollectionID)' AND ComplianceState = 1"
start-sleep 20
Get-CMCollectionMember -CollectionName "Compliant Machines" | select Name

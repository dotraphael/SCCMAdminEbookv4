$swrule = Get-CMSoftwareMeteringRule -ProductName Notepad
$CollUpdate = New-CMSchedule -Start "01/01/2015 9:00 PM" -DayOfWeek Saturday -RecurCount 1
$NewCol = New-CMDeviceCollection -Name "Computers that Run Notepad.exe Last 30 days" -LimitingCollectionName "All Systems" -RefreshSchedule $CollUpdate -RefreshType Both
Add-CMDeviceCollectionQueryMembershipRule -CollectionId $NewCol.CollectionID -RuleName "Software Metering Rule Notepad"  -QueryExpression "select * from SMS_R_System inner join SMS_MonthlyUsageSummary on SMS_MonthlyUsageSummary.ResourceID = SMS_R_System.ResourceID inner join SMS_MeteredFiles on SMS_MeteredFiles.FileID = SMS_MonthlyUsageSummary.FileID and SMS_MeteredFiles.SecurityKey = '$($swrule.SecurityKey)' where DateDiff(dd, SMS_MonthlyUsageSummary.LastUsage, GetDate()) < 30"
start-sleep 20
Get-CMCollectionMember -CollectionName "Computers that Run Notepad.exe Last 30 days" | select Name


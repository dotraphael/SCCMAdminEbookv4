$CollUpdate = New-CMSchedule -Start "01/01/2015 9:00 PM" -DayOfWeek Saturday -RecurCount 1
$Collection = New-CMDeviceCollection -Name "Workstation OU" -LimitingCollectionName "All Systems" -RefreshSchedule $CollUpdate -RefreshType Both
Add-CMDeviceCollectionQueryMembershipRule -CollectionId $Collection.CollectionID -RuleName "Workstation OU"  -QueryExpression "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.SystemOUName like 'CLASSROOM.INTRANET/CLASSROOM/WORKSTATIONS/%'"
start-sleep 20
Get-CMCollectionMember -CollectionName "Workstation OU" | select Name
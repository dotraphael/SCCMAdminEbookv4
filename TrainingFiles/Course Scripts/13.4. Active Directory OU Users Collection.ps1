$CollUpdate = New-CMSchedule -Start "01/01/2015 9:00 PM" -DayOfWeek Saturday -RecurCount 1
$Collection = New-CMUserCollection -Name "Users OU" -LimitingCollectionName "All Users and User Groups" -RefreshSchedule $CollUpdate -RefreshType Both
Add-CMUserCollectionQueryMembershipRule -CollectionId $Collection.CollectionID -RuleName "Users OU"  -QueryExpression "select *  from  SMS_R_User where SMS_R_User.UserOUName = 'CLASSROOM.INTRANET/CLASSROOM/USERS'"
start-sleep 20
Get-CMCollectionMember -CollectionName "Users OU" | select Name
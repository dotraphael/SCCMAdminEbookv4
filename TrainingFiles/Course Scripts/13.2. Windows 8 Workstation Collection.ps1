$CollUpdate = New-CMSchedule -Start "01/01/2015 9:00 PM" -DayOfWeek Saturday -RecurCount 1
$Collection = New-CMDeviceCollection -Name "Windows 8 Workstations" -LimitingCollectionName "All Systems" -RefreshSchedule $CollUpdate -RefreshType Both
Add-CMDeviceCollectionQueryMembershipRule -CollectionId $Collection.CollectionID -RuleName "Windows 8"  -QueryExpression "select * from SMS_R_System where OperatingSystemNameandVersion like 'Microsoft Windows NT Workstation 6.3%'"
start-sleep 20
Get-CMCollectionMember -CollectionName "Windows 8 Workstations" | select Name
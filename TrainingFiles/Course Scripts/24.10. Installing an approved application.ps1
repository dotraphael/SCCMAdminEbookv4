$UserSID = ((gwmi -query "select * from win32_useraccount where name = '$($env:USERNAME)' and domain='$($env:USERDOMAIN)'").SID).replace('-','_')
$sched = ([wmi]"root\ccm\Policy\$UserSID\ActualConfig:CCM_Scheduler_ScheduledMessage.ScheduledMessageID='{00000000-0000-0000-0000-000000000026}'");
$sched.Triggers = @('SimpleInterval;Minutes=1;MaxRandomDelayMinutes=0');
$sched.Put()
start-sleep 10

$sched = ([wmi]"root\ccm\Policy\$UserSID\ActualConfig:CCM_Scheduler_ScheduledMessage.ScheduledMessageID='{00000000-0000-0000-0000-000000000027}'");
$sched.Triggers = @('SimpleInterval;Minutes=1;MaxRandomDelayMinutes=0');
$sched.Put()
start-sleep 60

$AppName = "Java8"
$app = gwmi -Namespace 'root\CCM\ClientSDK' -Class 'CCM_Application' | Where-Object { ($_.Name -eq "$($AppName)") -and ($_.InstallState -eq "NotInstalled")}

if ($App.ApplicabilityState -eq "NotApplicable") {
    Write-host "'$($app.Name)' not applicable." -ForegroundColor Yellow
} else {
    Write-host "'$($app.Name)' is applicable."
}


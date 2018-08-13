$UserSID = ((gwmi -query "select * from win32_useraccount where name = '$($env:USERNAME)' and domain='$($env:USERDOMAIN)'").SID).replace('-','_')
$sched = ([wmi]"root\ccm\Policy\$UserSID\ActualConfig:CCM_Scheduler_ScheduledMessage.ScheduledMessageID='{00000000-0000-0000-0000-000000000026}'");
$sched.Triggers = @('SimpleInterval;Minutes=1;MaxRandomDelayMinutes=0');
$sched.Put()
start-sleep 10

$sched = ([wmi]"root\ccm\Policy\$UserSID\ActualConfig:CCM_Scheduler_ScheduledMessage.ScheduledMessageID='{00000000-0000-0000-0000-000000000027}'");
$sched.Triggers = @('SimpleInterval;Minutes=1;MaxRandomDelayMinutes=0');
$sched.Put()
start-sleep 60

$AppName = "Firefox 49"
$app = gwmi -Namespace 'root\CCM\ClientSDK' -Class 'CCM_Application' | Where-Object { ($_.Name -eq "$($AppName)") -and ($_.InstallState -eq "NotInstalled") -and ($_.AllowedActions -contains "Install")}

[int]$code = Invoke-WmiMethod -Namespace 'root\CCM\ClientSDK' -Class 'CCM_Application' -Name Install -ArgumentList @(0, $app.Id, $app.IsMachineTarget, $false, 'High', $app.Revision) | select -ExpandProperty ReturnValue

if ($code -ne 0) {
    throw "Error invoking Installation of '$($app.Name)' ($code)."
} else {
    "Successfully invoked Installation of '$($app.Name)'."
}


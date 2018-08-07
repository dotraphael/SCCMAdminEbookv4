$SMSCli = [wmiclass] "root\ccm:SMS_Client"
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000021}")
start-sleep 10
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000022}")
Start-Sleep 60

for($i=1; $i -le 3; $i++){
	Start-Process -Filepath ("notepad.exe")
	start-sleep 60
	Stop-Process -Name notepad
	start-sleep 10
}

$SMSCli = [wmiclass] "root\ccm:SMS_Client"
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000031}")

Start-Sleep 60

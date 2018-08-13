$SMSCli = [wmiclass] "root\ccm:SMS_Client"
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000021}")
start-sleep 10
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000022}")
Start-Sleep 60

$AppName = "Google Chrome"
$app = gwmi -Namespace 'root\CCM\ClientSDK' -Class 'CCM_Application' | Where-Object { ($_.Name -eq "$($AppName)") -and ($_.InstallState -eq "NotInstalled") -and ($_.AllowedActions -contains "Install")}

[int]$code = Invoke-WmiMethod -Namespace 'root\CCM\ClientSDK' -Class 'CCM_Application' -Name Install -ArgumentList @(0, $app.Id, $app.IsMachineTarget, $false, 'High', $app.Revision) | select -ExpandProperty ReturnValue

if ($code -ne 0) {
	throw "Error invoking Installation of '$($app.Name)' ($code)."
} else {
	"Successfully invoked Installation of '$($app.Name)'."
}
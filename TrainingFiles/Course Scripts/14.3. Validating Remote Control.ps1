$SMSCli = [wmiclass] "root\ccm:SMS_Client"
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000021}")
start-sleep 10
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000022}")
Start-Sleep 60

$groupName = "ConfigMgr Remote Control Users"
$LocalGroup = [ADSI]("WinNT://./$groupName,group")
$GMembers = $LocalGroup.psbase.invoke("Members")
$gmembers | foreach { $_.GetType().InvokeMember("Name",'GetProperty', $null, $_, $null) }

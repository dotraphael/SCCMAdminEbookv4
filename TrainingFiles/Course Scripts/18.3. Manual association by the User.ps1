#On the Client
$SMSCli = [wmiclass] "root\ccm:SMS_Client"
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000021}")
start-sleep 10
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000022}")
Start-Sleep 60

Start-Process -Filepath ("C:\Windows\CCM\ClientUX\SCClient.exe")
#continue steps 8 and 9

#On the Server
Get-CMUserDeviceAffinity -UserName "CLASSROOM\User02"
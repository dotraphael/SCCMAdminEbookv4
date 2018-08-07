#On the Client
Start-Process -Filepath ("\\srv0001\TrainingFiles\Source\Silverlight\Silverlight_x64.exe") -ArgumentList ("/q") -wait -NoNewWindow

$SMSCli = [wmiclass] "root\ccm:SMS_Client"
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000021}")
start-sleep 10
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000022}")
Start-Sleep 60

$IE=new-object -com internetexplorer.application
$IE.Visible = $true
$IE.navigate("http://SRV0002.classroom.intranet/CMApplicationCatalog")
#once the IE is open Click My Devices and select "I regularly use this computer to do my work".

#On the Server
Get-CMUserDeviceAffinity -UserName "CLASSROOM\User02"
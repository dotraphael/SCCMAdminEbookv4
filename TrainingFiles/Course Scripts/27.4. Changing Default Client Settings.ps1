#on the server
$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"
$ClientSettingsName = "Default Client Agent Settings"
Set-CMClientSetting -EndpointProtection -Name "$ClientSettingsName" -Enable $True -InstallEndpointProtectionClient $true -DisableFirstSignatureUpdate $False 

#on client machines
#update policies
$SMSCli = [wmiclass] "root\ccm:SMS_Client"
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000021}")
start-sleep 10
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000022}")
Start-Sleep 60


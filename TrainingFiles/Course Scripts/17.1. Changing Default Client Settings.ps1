$SiteCode = "001"

$ClientSettingsName = "Default Client Agent Settings"
$schedule = New-CMSchedule -RecurCount 1 -RecurInterval Days
Set-CMClientSetting -Name "$ClientSettingsName" -SoftwareMetering -Enable $True -Schedule $schedule

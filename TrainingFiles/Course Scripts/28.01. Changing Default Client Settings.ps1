$Schedule = New-CMSchedule -RecurCount 1 -RecurInterval Days

$ClientSettingsName = "Default Client Agent Settings"
Set-CMClientSetting -Compliance -Name "$ClientSettingsName" -EnableComplianceEvaluation $true -Schedule $Schedule

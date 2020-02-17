$ScanSchedule = New-CMSchedule -RecurCount 1 -RecurInterval Days
$DeploymentReEvaluation = New-CMSchedule -RecurCount 3 -RecurInterval Days

$ClientSettingsName = "Default Client Agent Settings"
Set-CMClientSetting -Name "$ClientSettingsName" -SoftwareUpdate -BatchingTimeout 7 -DeploymentEvaluationSchedule $DeploymentReEvaluation -Enable $True -EnforceMandatory $True -ScanSchedule $ScanSchedule -TimeUnit Days

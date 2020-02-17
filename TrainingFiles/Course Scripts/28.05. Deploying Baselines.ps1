$Name = "Workstation Baseline" 
$schedule = New-CMSchedule -RecurCount 1 -RecurInterval Days

New-CMBaselineDeployment -Name $Name -CollectionName "Windows 10 Workstations" -EnableEnforcement $true -Schedule $schedule

$Task = Get-ScheduledTask -TaskName "Configuration Manager Health Evaluation"
$task.Principal.UserId # should be System
$task.Actions.Execute # should be c:\windows\ccm\ccmeval.exe
$task.Settings.AllowDemandStart # should be true
$task.Settings.StartWhenAvailable # should be true

#On SRV0002
$SiteCode = "001"

$task = Get-CMSiteSummaryTask -TaskName "Client Health Scheduled Task"
$Task.RunNow = $true
$Task.Put()
Start-Sleep 60
 
$Device = Get-CMDevice -Name "WKS0001" -Fast
gwmi -namespace "root\sms\site_$SiteCode" -query "select * from SMS_CH_EvalResult where ResourceID = $($Device.ResourceID)" | select HealthCheckDescription

$Device = Get-CMDevice -Name "WKS0002" -Fast
gwmi -namespace "root\sms\site_$SiteCode" -query "select * from SMS_CH_EvalResult where ResourceID = $($Device.ResourceID)" | select HealthCheckDescription

#On SRV0001
Get-ADComputer "WKS0002" | Move-ADObject -TargetPath 'OU=Enabled,OU=Workstations,OU=Classroom,DC=classroom,DC=intranet'

#On WKS0002
#get service information
Get-Service -Name BITS

#force group policy update
Start-Process -Filepath ("gpupdate") -ArgumentList ("/force") -wait -NoNewWindow
Start-sleep 10

#force group policy update
Start-Process -Filepath ("gpupdate") -ArgumentList ("/force") -wait -NoNewWindow
Start-sleep 10

#get service information
Get-Service -Name BITS

#execute evaluation
Start-Process -Filepath ("c:\windows\ccm\ccmeval.exe") -wait -NoNewWindow
Start-Sleep 60

#On SRV0002
$SiteCode = "001"

$task = Get-CMSiteSummaryTask -TaskName  "Client Health Scheduled Task"
$Task.RunNow = $true
$Task.Put()
Start-Sleep 60
 
$Device = Get-CMDevice -Name "WKS0002"
gwmi -namespace "root\sms\site_$SiteCode" -query "select * from SMS_CH_EvalResult where ResourceID = $($Device.ResourceID)" | select HealthCheckDescription

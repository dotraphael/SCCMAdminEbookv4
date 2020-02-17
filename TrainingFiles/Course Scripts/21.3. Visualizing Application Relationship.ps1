. c:\TrainingFiles\Scripts\ShowDependentApplications_v0_9.ps1

$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
$AppName = "App-V Client 5.0"

ShowDependentApplications -ApplicationName "$AppName" -SiteCode "$SiteCode" -SiteServer "$servername"

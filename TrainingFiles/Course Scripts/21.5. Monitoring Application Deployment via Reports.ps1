$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
$AppName = "Google Chrome"
$ColName = "Workstation OU"

#Open Report
Invoke-CMReport -ReportPath "Software Distribution - Application Monitoring/Application compliance" -SiteCode "$SiteCode" -SrsServerName "$servername" -ReportParameter @{"Application"="$($AppName)"; "Collection"="$($ColName)"}
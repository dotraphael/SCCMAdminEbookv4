$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

#Open Report
Invoke-CMReport -ReportPath "Compliance and Settings Management/Summary compliance by configuration baseline" -SiteCode "$SiteCode" -SrsServerName "$servername"


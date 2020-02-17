$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

#Open Report
$dict = @{"Device Name"="WKS0004.CLASSROOM"; "Vendor"="Microsoft"; "Update Class"="Critical Updates"; }
Invoke-CMReport -ReportPath "Software Updates - A Compliance/Compliance 5 - Specific computer" -SiteCode "$SiteCode" -SrsServerName "$servername" -ReportParameter $dict

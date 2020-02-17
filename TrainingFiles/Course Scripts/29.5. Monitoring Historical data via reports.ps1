$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

#Open Report
$dict = @{"Device Name"="WKS0001" }
Invoke-CMReport -ReportPath "Data Warehouse/General hardware inventory - Historical" -SiteCode "$SiteCode" -SrsServerName "$servername" -ReportParameter $dict

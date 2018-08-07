$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

$swrule = Get-CMSoftwareMeteringRule -ProductName Notepad
$Date = Get-Date

#Open Report
$dict = @{"Rule Name"="$($swrule.ProductName)"; "Month (1-12)"="$($Date.Month)"; "Year"="$($Date.Year)" }
Invoke-CMReport -ReportPath "Software Metering/Users that have run a specific metered software program" -SiteCode "$SiteCode" -SrsServerName "$servername" -ReportParameter $dict

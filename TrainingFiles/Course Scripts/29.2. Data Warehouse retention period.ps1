$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

Set-CMDataWarehouseServicePoint -SiteSystemServerName $servername -DataRetentionDays 1460 -SiteCode $SiteCode

$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
$AppName = "Google Chrome"

Get-CMDistributionStatus | Where-Object {$_.SoftwareName -eq $AppName} | select Targeted, NumberErrors, NumberInProgress, NumberSuccess, NumberUnknown
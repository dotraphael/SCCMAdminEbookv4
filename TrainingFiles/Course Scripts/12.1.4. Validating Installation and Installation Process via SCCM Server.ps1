$SiteCode = "001"

Invoke-CMCollectionUpdate -Name "All Systems"
Start-sleep 10

Get-CMDevice -Name "WKS000?" | select Name, IsClient, SiteCode, ClientActiveStatus

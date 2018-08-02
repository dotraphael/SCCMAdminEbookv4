$SiteCode = "001"

Invoke-CMCollectionUpdate -Name "All Systems"
Start-sleep 10

@("WKS0001", "WKS0002", "WKS0004") | foreach { Get-CMDevice -Name $_ | Install-CMClient -SiteCode "$SiteCode" }

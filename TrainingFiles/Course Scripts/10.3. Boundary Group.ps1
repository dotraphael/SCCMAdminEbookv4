$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
 
New-CMBoundaryGroup -Name "Training Lab" -AddSiteSystemServerName @($servername) -DefaultSiteCode $SiteCode
Add-CMBoundaryToGroup -BoundaryGroupName "Training Lab" -BoundaryName "Training Lab Boundary"

$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
$sccmversion = '1806'

while ($true) {
	$SiteUpdate = Get-CMSiteUpdate -Name "Configuration Manager $($sccmversion)" -Fast | where {$_.UpdateType -eq 0}
	if ($SiteUpdate -ne $null) {
		if ($SiteUpdate.State -ne 262146) {
			Write-Host "Update is in Downloading state..."
			Start-Sleep 30
		} else {
			Write-Host "Update is ready, executing pre-req"
			Invoke-CMSiteUpdatePrerequisiteCheck -Name "Configuration Manager $($sccmversion)"
			break
		}
	} 
}
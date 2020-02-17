$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
$mecmversion = '1910'

while ($true) {
	$SiteUpdate = Get-CMSiteUpdate -Name "Configuration Manager $($mecmversion)" -Fast | where {$_.UpdateType -eq 0}
	if ($SiteUpdate -ne $null) {
		if ($SiteUpdate.State -ne 262146) {
			Write-Host "Update is in Downloading state..."
			Start-Sleep 30
		} else {
			Write-Host "Update is ready, executing pre-req"
			Invoke-CMSiteUpdatePrerequisiteCheck -Name "Configuration Manager $($mecmversion)"
			break
		}
	} 
}
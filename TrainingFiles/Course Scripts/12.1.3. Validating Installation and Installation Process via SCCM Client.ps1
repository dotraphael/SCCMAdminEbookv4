while ($true) {
	$Process = Get-Process -Name ccmsetup -ErrorAction SilentlyContinue
	if ($Process -ne $null) { Start-Sleep 10 }
	else { Write-host "Process ccmsetup.exe does not exist or already finished"; break } 
}

while ($true) {
	$Process = Get-Process -Name ccmexec -ErrorAction SilentlyContinue
	if ($Process -eq $null) { Start-Sleep 10 }
	else { Write-host "Process ccmexec exist"; break } 
}
start-sleep 60

"Client is assigned to $((Invoke-WMIMethod -Namespace root\ccm -Class SMS_Client -Name GetAssignedSite).sSiteCode)"

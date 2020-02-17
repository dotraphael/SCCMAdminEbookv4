$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"

Set-CMSoftwareUpdatePointComponent -SiteCode $SiteCode -ImmediatelyExpireSupersedence $True -AddUpdateClassification "Definition Updates" -AddProduct @('System Center Endpoint Protection', 'Windows Defender')
Start-Sleep 20
Sync-CMSoftwareUpdate -FullSync $True
Start-Sleep 60
#6705 = Database
#6704 = Inprogress (WSUS Server)
#6702 = Success
#6702 = Starting
while ($true) {
	$return = Get-CMSoftwareUpdateSyncStatus | select LastSyncErrorCode, LastSyncState
	Write-Output $return
	if ($return.LastSyncState -ne 6702) {start-sleep 10 } else { break }
}

$SiteCode = "001"

Set-CMSoftwareUpdatePointComponent -SiteCode $SiteCode -AddProduct @('Windows 8.1', 'Windows 10', 'Windows 10, version 1903 and later')
Start-Sleep 20
Sync-CMSoftwareUpdate -FullSync $True
start-sleep 60

#6705 = Database
#6704 = Inprogress (WSUS Server)
#6702 = Success
#6702 = Starting
while ($true) {
	$return = Get-CMSoftwareUpdateSyncStatus | select LastSyncErrorCode, LastSyncState
	Write-Output $return
	if ($return.LastSyncState -ne 6702) {start-sleep 10 } else { break }
}

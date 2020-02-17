$SiteCode = "001"

Sync-CMSoftwareUpdate -FullSync $True
start-sleep 30

#6705 = Database
#6704 = Inprogress (WSUS Server)
#6702 = Success
#6702 = Starting
while ($true) {
	$return = Get-CMSoftwareUpdateSyncStatus | select LastSyncErrorCode, LastSyncState
	Write-Output $return
	if ($return.LastSyncState -ne 6702) {start-sleep 10 } else { break }
}

Set-CMSoftwareUpdatePointComponent -SiteCode $SiteCode -AddCompany @('Patch My PC')
Start-Sleep 20

Sync-CMSoftwareUpdate -FullSync $True
start-sleep 30

#6705 = Database
#6704 = Inprogress (WSUS Server)
#6702 = Success
#6702 = Starting
while ($true) {
	$return = Get-CMSoftwareUpdateSyncStatus | select LastSyncErrorCode, LastSyncState
	Write-Output $return
	if ($return.LastSyncState -ne 6702) {start-sleep 10 } else { break }
}

Get-CMSoftwareUpdate -Name '*Firefox*' -Fast

Set-CMSoftwareUpdatePointComponent -SiteCode $SiteCode -EnableThirdPartyUpdates $true

$Component =  gwmi -Namespace "root\SMS\site_$($SiteCode)" -query "select * from SMS_SCI_Component where FileType = 2 and ItemName = 'SMS_WSUS_SYNC_MANAGER|SMS Site Server' and ItemType='Component' and SiteCode='$($SiteCode)'"
$props = $component.Props
$prop = $props | where {$_.PropertyName -eq 'EnableThirdPartyUpdates'}
$prop.Value = 3
$component.Props = $props
$component.Put() | Out-Null

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

if (-not (Get-CMCertificate | where {($_.IssuedTo -eq 'CN=WSUS Publishers Self-signed') -and ($_.Type -eq 6)})) {
    Write-host 'Certificate not generated yet'
    start-sleep 10
} else {
    write-host 'WSUS Certificate cenerated'
}

Set-CMClientSettingSoftwareUpdate -DefaultSetting -EnableThirdPartyUpdates $true
Set-CMClientSettingSoftwareUpdate -Name 'Windows 10 Express Updates' -EnableThirdPartyUpdates $true
start-sleep 20

$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"

if ((Get-CMSiteSystemServer -SiteSystemServerName "$servername") -eq $null) { New-CMSiteSystemServer -SiteCode $SiteCode -UseSiteServerAccount -ServerName $servername }
Add-CMEndpointProtectionPoint -ProtectionService BasicMembership -SiteSystemServerName "$ServerName" -SiteCode $SiteCode
start-sleep 90

while ($true) {
	$component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_ENDPOINT_PROTECTION_CONTROL_MANAGER' and stmsg.MessageID = 1013 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null)     {
        Write-Host "Found SMS_ENDPOINT_PROTECTION_CONTROL_MANAGER 1013 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
	$component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_ENDPOINT_PROTECTION_CONTROL_MANAGER' and stmsg.MessageID = 1014 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null)     {
        Write-Host "Found SMS_ENDPOINT_PROTECTION_CONTROL_MANAGER 1014 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
	$component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_ENDPOINT_PROTECTION_CONTROL_MANAGER' and stmsg.MessageID = 1015 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null)     {
        Write-Host "Found SMS_ENDPOINT_PROTECTION_CONTROL_MANAGER 1015 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
	$component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_ENDPOINT_PROTECTION_CONTROL_MANAGER' and stmsg.MessageID = 500 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null)     {
        Write-Host "Found SMS_ENDPOINT_PROTECTION_CONTROL_MANAGER 500 id's"
        break
    } else { Start-Sleep 10 }
}

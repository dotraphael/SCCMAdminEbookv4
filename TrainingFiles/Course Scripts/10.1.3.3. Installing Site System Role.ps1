$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

if ((Get-CMSiteSystemServer -SiteSystemServerName "$servername") -eq $null) { New-CMSiteSystemServer -SiteCode $SiteCode -UseSiteServerAccount -ServerName $servername }
Add-CMFallbackStatusPoint -SiteSystemServerName $servername -SiteCode $siteCode 

start-sleep 90

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_FALLBACK_STATUS_POINT' and stmsg.MessageID = 1013 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_FALLBACK_STATUS_POINT 1013 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_FALLBACK_STATUS_POINT' and stmsg.MessageID = 1014 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_FALLBACK_STATUS_POINT 1014 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_FALLBACK_STATUS_POINT' and stmsg.MessageID = 1015 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_FALLBACK_STATUS_POINT 1015 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_FALLBACK_STATUS_POINT' and stmsg.MessageID = 500 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_FALLBACK_STATUS_POINT 500 id's"
        break
    } else { Start-Sleep 10 }
}

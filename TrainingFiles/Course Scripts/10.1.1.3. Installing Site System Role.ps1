$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

if ((Get-CMSiteSystemServer -SiteSystemServerName "$servername") -eq $null) { New-CMSiteSystemServer -SiteCode $SiteCode -UseSiteServerAccount -ServerName $servername }
Add-CMDistributionPoint -CertificateExpirationTimeUtc "$((Get-Date).AddYears(20).ToString())" -SiteSystemServerName $servername -SiteCode $siteCode -ClientConnectionType Intranet -InstallInternetServer

start-sleep 90

$component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_DISTRIBUTION_MANAGER' and stmsg.MessageID = 2302 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '$SiteCode'"
if ($component -ne $null) {
    Write-Host "ERROR: Found SMS_DISTRIBUTION_MANAGER 2302 id's" -ForegroundColor Red
}

$component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_DISTRIBUTION_MANAGER' and stmsg.MessageID = 2391 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '$SiteCode'"
if ($component -ne $null) {
    Write-Host "ERROR: Found SMS_DISTRIBUTION_MANAGER 2391 id's" -ForegroundColor Red
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_DISTRIBUTION_MANAGER' and stmsg.MessageID = 2362 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_DISTRIBUTION_MANAGER 2362 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_DISTRIBUTION_MANAGER' and stmsg.MessageID = 2399 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_DISTRIBUTION_MANAGER 2399 id's"
        break
    } else { Start-Sleep 10 }
}

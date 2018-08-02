$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

if ((Get-CMSiteSystemServer -SiteSystemServerName "$servername") -eq $null) { New-CMSiteSystemServer -SiteCode $SiteCode -UseSiteServerAccount -ServerName $servername }
Add-CMManagementPoint -SiteSystemServerName $servername -SiteCode $siteCode 

start-sleep 90

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_MP_CONTROL_MANAGER' and stmsg.MessageID = 1013 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_MP_CONTROL_MANAGER 1013 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_MP_CONTROL_MANAGER' and stmsg.MessageID = 1014 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_MP_CONTROL_MANAGER 1014 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_MP_CONTROL_MANAGER' and stmsg.MessageID = 1015 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_MP_CONTROL_MANAGER 1015 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_MP_CONTROL_MANAGER' and stmsg.MessageID = 500 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_MP_CONTROL_MANAGER 500 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_MP_CONTROL_MANAGER' and stmsg.MessageID = 5460 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_MP_CONTROL_MANAGER 5460 id's"
        break
    } else { Start-Sleep 10 }
}

$web = New-Object -ComObject msxml2.xmlhttp
$url = "http://$($servername):80/sms_mp/.sms_aut?mplist"
try {   
	$web.open('GET', $url, $false)
	$web.send()
			
	Write-host "MPList HTTP Return $($web.status)"
} catch {
	Write-host "MPList ERROR: $($_)" -ForegroundColor Red
}

$web = New-Object -ComObject msxml2.xmlhttp
$url = "http://$($servername):80/sms_mp/.sms_aut?mpcert"
try {   
	$web.open('GET', $url, $false)
	$web.send()
			
	Write-host "MPCert HTTP Return $($web.status)"
} catch {
	Write-host "MPCert ERROR: $($_)" -ForegroundColor Red
}

$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
$servernameNetbios = "SRV0002"

if ((Get-CMSiteSystemServer -SiteSystemServerName "$servername") -eq $null) { New-CMSiteSystemServer -SiteCode $SiteCode -UseSiteServerAccount -ServerName $servername }
Add-CMApplicationCatalogWebsitePoint -ApplicationWebServicePointServerName "$servername" -CommunicationType HTTP -SiteSystemServerName "$servername" -NetBiosName $servernameNetbios -OrganizationName "Training Lab" -Port 80 -SiteCode $SiteCode -WebApplicationName 'CMApplicationCatalog'
start-sleep 90

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_PORTALWEB_CONTROL_MANAGER' and stmsg.MessageID = 1013 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_PORTALWEB_CONTROL_MANAGER 1013 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_PORTALWEB_CONTROL_MANAGER' and stmsg.MessageID = 1014 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_PORTALWEB_CONTROL_MANAGER 1014 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_PORTALWEB_CONTROL_MANAGER' and stmsg.MessageID = 1015 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_PORTALWEB_CONTROL_MANAGER 1015 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_PORTALWEB_CONTROL_MANAGER' and stmsg.MessageID = 500 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_PORTALWEB_CONTROL_MANAGER 500 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_PORTALWEB_CONTROL_MANAGER' and stmsg.MessageID = 8002 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_PORTALWEB_CONTROL_MANAGER 8002 id's"
        break
    } else { Start-Sleep 10 }
}

$web = New-Object -ComObject msxml2.xmlhttp
$url = "http://$($servername):80/CMApplicationCatalog"
while ($true) {
    try {   
        $web.open('GET', $url, $false, "classroom\sccmadmin", 'Pa$$w0rd')
	    $web.send()

	    if ($web.status -eq "404") { start-sleep 10 }
	    if ($web.status -eq "200") {
		    Write-Host "Found CMApplicationCatalog site"
       		    break
	    }
	    if ($web.status -eq "500") {
		    Write-Host "ERROR: SMS_PORTALWEB_CONTROL_MANAGER is returning error 500" -ForegroundColor
            break
	    }
    } catch {
	    #
    }
}

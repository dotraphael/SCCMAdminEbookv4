$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
$sqlServerInstance = 'SSRS'

$Secure = 'Pa$$w0rd'| ConvertTo-SecureString -AsPlainText -Force
$account = "CLASSROOM\svc_ssrsea"
New-CMAccount -Name "$account" -Password $Secure -SiteCode "$SiteCode"

if ((Get-CMSiteSystemServer -SiteSystemServerName "$servername") -eq $null) { New-CMSiteSystemServer -SiteCode $SiteCode -UseSiteServerAccount -ServerName $servername }
Add-CMReportingServicePoint -ReportServerInstance $sqlServerInstance -SiteSystemServerName "$servername" -UserName "$account" -DatabaseName "CM_$SiteCode" -DatabaseServerName "$servername" -FolderName "ConfigMgr_$SiteCode" -SiteCode "$SiteCode"  

start-sleep 90

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_SRS_REPORTING_POINT' and stmsg.MessageID = 1013 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_SRS_REPORTING_POINT 1013 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_SRS_REPORTING_POINT' and stmsg.MessageID = 1014 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_SRS_REPORTING_POINT 1014 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_SRS_REPORTING_POINT' and stmsg.MessageID = 1015 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_SRS_REPORTING_POINT 1015 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_SRS_REPORTING_POINT' and stmsg.MessageID = 500 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_SRS_REPORTING_POINT 500 id's"
        break
    } else { Start-Sleep 10 }
}

$web = New-Object -ComObject msxml2.xmlhttp
$url = "http://localhost:80/reportserver/ConfigMgr_$SiteCode"
while ($true) {
    try {   
        $web.open('GET', $url, $false)
		$web.send()

		if ($web.status -eq "404") { start-sleep 10 }
		if ($web.status -eq "200") {
				Write-Host "Found ConfigMgr_$SiteCode reporting site"
        		break
		}
    } catch {
	# 
    }
}

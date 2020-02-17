$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
$account = "CLASSROOM\svc_ssrsea"

if ((Get-CMSiteSystemServer -SiteSystemServerName "$servername") -eq $null) { New-CMSiteSystemServer -SiteCode $SiteCode -UseSiteServerAccount -ServerName $servername }
Add-CMDataWarehouseServicePoint -SiteSystemServerName $ServerName -UserName $account -DataWarehouseDatabaseName "CM_$($SiteCode)_DW" -DataWarehouseDatabaseServerName $ServerName -DataWarehouseSqlPort 1433 -SiteCode $SiteCode -WeekFrequency 1
start-sleep 90

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'DATA_WAREHOUSE_SERVICE_POINT' and stmsg.MessageID = 1013 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found DATA_WAREHOUSE_SERVICE_POINT 1013 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true)
{
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'DATA_WAREHOUSE_SERVICE_POINT' and stmsg.MessageID = 1014 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found DATA_WAREHOUSE_SERVICE_POINT 1014 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'DATA_WAREHOUSE_SERVICE_POINT' and stmsg.MessageID = 1015 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found DATA_WAREHOUSE_SERVICE_POINT 1015 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'DATA_WAREHOUSE_SERVICE_POINT' and stmsg.MessageID = 11201 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found DATA_WAREHOUSE_SERVICE_POINT 11201 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'DATA_WAREHOUSE_SERVICE_POINT' and stmsg.MessageID = 11203 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found DATA_WAREHOUSE_SERVICE_POINT 11203 id's"
        break
    } else { Start-Sleep 10 }
}

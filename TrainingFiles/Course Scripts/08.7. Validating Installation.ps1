$component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_DATABASE_NOTIFICATION_MONITOR' and stmsg.MessageID = 2420 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
if ($component -ne $null) {
    Write-Host "Warning: Found SMS_DATABASE_NOTIFICATION_MONITOR 2420 id's" -ForegroundColor Yellow
}

$component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_SITE_SQL_BACKUP' and stmsg.MessageID = 4959 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
if ($component -ne $null) {
    Write-Host "Error: Missing SQL SPN Information - https://technet.microsoft.com/en-us/library/hh427336.aspx#BKMK_ManageSPNforDBSrv" -ForegroundColor Red
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_SITE_COMPONENT_MANAGER' and stmsg.MessageID = 1027 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
    if ($component -ne $null) {
        Write-Host "Found SMS_SITE_COMPONENT_MANAGER 2017 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_HIERARCHY_MANAGER' and stmsg.MessageID = 3306 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
    if ($component -ne $null) {
        Write-Host "Found SMS_HIERARCHY_MANAGER 3306 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_001") -query "select stmsg.RecordID from SMS_StatMsg stmsg where stmsg.Component = 'SMS_HIERARCHY_MANAGER' and stmsg.MessageID = 3323 and stmsgin.SiteCode = '001'"
    if ($component -ne $null) {
        Write-Host "Found SMS_HIERARCHY_MANAGER 3323 id's"
        break
    } else { Start-Sleep 10 }
}

$component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_HIERARCHY_MANAGER' and stmsg.MessageID = 3351 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
if ($component -ne $null) {
    Write-Host "Found SMS_HIERARCHY_MANAGER 3351 id's"
    break
} 

$component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_HIERARCHY_MANAGER' and stmsg.MessageID = 3353 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
if ($component -ne $null) {
    Write-Host "Error: Found SMS_HIERARCHY_MANAGER 3353 id's" -ForegroundColor Red
    break
} 

$component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_HIERARCHY_MANAGER' and stmsg.MessageID = 4909 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
if ($component -ne $null) {
    Write-Host "Error: Found SMS_HIERARCHY_MANAGER 4909 id's" -ForegroundColor Red
    break
} 

$component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_HIERARCHY_MANAGER' and stmsg.MessageID = 4911 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
if ($component -ne $null) {
    Write-Host "Found SMS_HIERARCHY_MANAGER 4911 id's"
} else {
    Write-Host "ERROR: Not Found SMS_HIERARCHY_MANAGER 4911 id's" -ForegroundColor Red
}

$component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_HIERARCHY_MANAGER' and stmsg.MessageID = 4012 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
if ($component -ne $null) {
    Write-Host "Error: Found SMS_HIERARCHY_MANAGER 4012 id's" -ForegroundColor Red
    break
} 

$component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_HIERARCHY_MANAGER' and stmsg.MessageID = 4913 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
if ($component -ne $null) {
    Write-Host "ERROR: Found SMS_HIERARCHY_MANAGER 4913 id's" -ForegroundColor Red
}

$component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_REPLICATION_CONFIGURATION_MONITOR' and stmsg.MessageID = 4629 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
if ($component -ne $null) {
    Write-Host "Found SMS_REPLICATION_CONFIGURATION_MONITOR 4629 id's"
}

$component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_REPLICATION_CONFIGURATION_MONITOR' and stmsg.MessageID = 620 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
if ($component -ne $null) {
    Write-Host "Error: Found SMS_REPLICATION_CONFIGURATION_MONITOR 620 id's" -ForegroundColor Red
}

$component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_DMP_DOWNLOADER' and stmsg.MessageID = 4629 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
if ($component -ne $null) {
    Write-Host "Found SMS_DMP_DOWNLOADER 4629 id's"
}

$component = gwmi -Namespace ("root\sms\site_001") -query "select stmsg.RecordID from SMS_StatMsg stmsg where stmsg.Component = 'SMS_DMP_DOWNLOADER' and stmsg.MessageID = 9700 and stmsg.SiteCode = '001'"
if ($component -ne $null) {
    Write-Host "Error: Found SMS_DMP_DOWNLOADER 9700 id's" -ForegroundColor Red
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_001") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_WINNT_SERVER_DISCOVERY_AGENT' and stmsg.MessageID = 4202 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '001'"
    if ($component -ne $null) {
        Write-Host "Found SMS_WINNT_SERVER_DISCOVERY_AGENT 4202 id's"
        break
    } else { Start-Sleep 10 }
}

if ($component -is [Array]) {
    $Total = $component[0].InsStrValue
} else {
    $Total = $component.InsStrValue
}

$roles = gwmi -Namespace ("root\sms\site_001") -query "select * from SMS_SCI_SysResUse where FileType=2 and RoleName != 'SMS Provider'"
if ($roles.count -ne $total) {
    Write-Host "ERROR: Found $($roles.count). expected $Total"  -ForegroundColor Red
} else {
    Write-Host "All $Total roles have been created"
}

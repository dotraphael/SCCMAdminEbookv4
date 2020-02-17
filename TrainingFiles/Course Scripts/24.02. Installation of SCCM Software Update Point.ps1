$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

if ((Get-CMSiteSystemServer -SiteSystemServerName "$servername") -eq $null) { New-CMSiteSystemServer -SiteCode $SiteCode -UseSiteServerAccount -ServerName $servername }
Add-CMSoftwareUpdatePoint -SiteSystemServerName "$ServerName" -ClientConnectionType "Intranet" -SiteCode $SiteCode -WsusiisPort 8530 -WsusiissslPort 8531 -WsusSsl $false

start-sleep 90

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsgin.InsStrValue from SMS_StatMsg stmsg inner join SMS_StatMsgInsStrings stmsgin on stmsg.RecordID = stmsgin.RecordID where stmsg.Component = 'SMS_WSUS_CONTROL_MANAGER' and stmsg.MessageID = 1013 and stmsgin.InsStrIndex = 0 and stmsgin.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_WSUS_CONTROL_MANAGER 1013 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true)
{
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_WSUS_CONTROL_MANAGER' and stmsg.MessageID = 1014 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_WSUS_CONTROL_MANAGER 1014 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_WSUS_CONTROL_MANAGER' and stmsg.MessageID = 1015 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_WSUS_CONTROL_MANAGER 1015 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_WSUS_CONTROL_MANAGER' and stmsg.MessageID = 500 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_WSUS_CONTROL_MANAGER 500 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_WSUS_CONFIGURATION_MANAGER' and stmsg.MessageID = 500 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_WSUS_CONFIGURATION_MANAGER 500 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_WSUS_CONFIGURATION_MANAGER' and stmsg.MessageID = 501 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_WSUS_CONFIGURATION_MANAGER 501 id's"
        break
    } else { Start-Sleep 10 }
}

$component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_WSUS_CONFIGURATION_MANAGER' and stmsg.MessageID = 6600 and stmsg.SiteCode = '$SiteCode'"
if ($component -ne $null) {
    Write-Host "ERROR: Found SMS_WSUS_CONFIGURATION_MANAGER 6600 id's" -ForegroundColor Red
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_WSUS_CONFIGURATION_MANAGER' and stmsg.MessageID = 4629 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_WSUS_CONFIGURATION_MANAGER 4629 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_WSUS_SYNC_MANAGER' and stmsg.MessageID = 500 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_WSUS_SYNC_MANAGER 500 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_WSUS_SYNC_MANAGER' and stmsg.MessageID = 501 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_WSUS_SYNC_MANAGER 501 id's"
        break
    } else { Start-Sleep 10 }
}

while ($true) {
    $component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_WSUS_SYNC_MANAGER' and stmsg.MessageID = 4629 and stmsg.SiteCode = '$SiteCode'"
    if ($component -ne $null) {
        Write-Host "Found SMS_WSUS_SYNC_MANAGER 4629 id's"
        break
    } else { Start-Sleep 10 }
}

$component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select stmsg.* from SMS_StatMsg stmsg where stmsg.Component = 'SMS_WSUS_SYNC_MANAGER' and stmsg.MessageID = 6703 and stmsg.SiteCode = '$SiteCode'"
if ($component -ne $null) {
    Write-Host "ERROR: Found SMS_WSUS_SYNC_MANAGER 6703 id's" -ForegroundColor Red
}

start-sleep 60
$Languages = @("Chinese (Simplified, China)", "French", "German", "Japanese", "Russian") 
$Classifications = @()
$Products = @()

#get list of all products
Get-WmiObject -Namespace "Root\SMS\Site_$SiteCode" SMS_UpdateCategoryInstance -Filter "(IsSubscribed = 'True') and (CategoryInstance_UniqueID like 'Product:%')" | foreach {$Products += $_.LocalizedCategoryInstanceName }

#get list of all classifications
Get-WmiObject -Namespace "Root\SMS\Site_$SiteCode" SMS_UpdateCategoryInstance -Filter "(IsSubscribed = 'True') and (CategoryInstance_UniqueID like 'UpdateClassification:%')" | foreach {$Classifications += $_.LocalizedCategoryInstanceName }

$schedule = New-CMSchedule -RecurCount 1 -RecurInterval Days
#remove all classifications, languages & products from sync
Set-CMSoftwareUpdatePointComponent -SiteCode $SiteCode -RemoveUpdateClassification $Classifications -RemoveLanguageSummaryDetail $Languages -RemoveLanguageUpdateFile $Languages -RemoveProduct $Products
start-sleep 20

#add Critical Updates only
Set-CMSoftwareUpdatePointComponent -SiteCode $SiteCode -AddUpdateClassification ('Critical Updates','Security Updates')

Set-CMSoftwareUpdatePointComponent -SiteCode $SiteCode -Schedule $Schedule -SynchronizeAction SynchronizeFromMicrosoftUpdate

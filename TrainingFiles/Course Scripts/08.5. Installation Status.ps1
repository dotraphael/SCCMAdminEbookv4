Get-CimInstance win32_service | where-object {$_.Name -in ("SMS_EXECUTIVE","SMS_SITE_BACKUP","SMS_SITE_COMPONENT_MANAGER","SMS_SITE_SQL_BACKUP","SMS_SITE_VSS_WRITER")} | select Name,StartMode,State,Status

$dn = New-Object System.DirectoryServices.DirectoryEntry
$dsLookFor = new-object System.DirectoryServices.DirectorySearcher($dn)
$dsLookFor.Filter = ("CN=SMS-SITE-001")
$dsLookFor.SearchScope = "subtree";
$dsLookFor.findOne()

Get-ChildItem -Path C:\ConfigMgr

$Groups = Gwmi win32_group | where { $_.Name -in ("ConfigMgr_CollectedFilesAccess", "ConfigMgr_DViewAccess", "SMS Admins", "SMS_SiteSystemToSiteServerConnection_MP_001", "SMS_SiteSystemToSiteServerConnection_SMSProv_001", "SMS_SiteSystemToSiteServerConnection_Stat_001", "SMS_SiteToSiteConnection_001") } | select Name
if ($Groups.Count -ne 7) { Write-Host "Should be 7 Groups" } else { "Groups OK" }

$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
 
$ClientSettingsName = "Default Client Agent Settings"
Set-CMClientSetting -ComputerAgentSettings -Name "$ClientSettingsName" -AddPortalToTrustedSiteList $True -AllowPortalToHaveElevatedTrust $True 
Set-CMClientSetting -Name "$ClientSettingsName" -UserDeviceAffinitySettings -AllowUserAffinity $True -AutoApproveAffinity $True

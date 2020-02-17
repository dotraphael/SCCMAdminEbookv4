$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
 
$ClientSettingsName = "Default Client Agent Settings"
Set-CMClientSetting -ComputerAgentSettings -Name "$ClientSettingsName" -BrandingTitle "Training Lab"

$schedule = New-CMSchedule -RecurCount 1 -RecurInterval Days
Set-CMClientSetting -HardwareInventorySettings -Name "$ClientSettingsName" -EnableHardwareInventory $True -InventorySchedule $Schedule


Set-CMClientSettingSoftwareCenter -DefaultSetting -EnableCustomize $true -CompanyName "Training Lab" -LogoFilePath "\\srv0001\TrainingFiles\Scripts\traininglab.jpg" -HideInstalledApplication $false

$dict = @{"FileName"="*.exe"; Exclude=$true; ExcludeWindirAndSubfolders=$true; Subdirectories=$true; Path="*"}
Set-CMClientSettingSoftwareInventory -DefaultSetting -Enable $True -Schedule $schedule -AddInventoryFileType $dict

Set-CMClientSetting -Name "$ClientSettingsName" -StateMessageSettings -StateMessagingReportingCycleMinutes 2
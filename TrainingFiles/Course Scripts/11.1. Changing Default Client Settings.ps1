$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
 
$ClientSettingsName = "Default Client Agent Settings"
Set-CMClientSetting -ComputerAgentSettings -Name "$ClientSettingsName" -BrandingTitle "Training Lab"

$schedule = New-CMSchedule -RecurCount 1 -RecurInterval Days
Set-CMClientSetting -HardwareInventorySettings -Name "$ClientSettingsName" -EnableHardwareInventory $True -InventorySchedule $Schedule

$dict = @{"FileName"="*.exe"; Exclude=$true; ExcludeWindirAndSubfolders=$true; Subdirectories=$true; Path="*"}
Set-CMClientSettingSoftwareInventory -DefaultSetting -Enable $True -Schedule $schedule -AddInventoryFileType $dict

Set-CMClientSetting -Name "$ClientSettingsName" -StateMessageSettings -StateMessagingReportingCycleMinutes 2

#change software center settings
$Encoded = [convert]::ToBase64String((Get-Content 'filesystem::\\srv0001\trainingfiles\Scripts\traininglab.jpg' -Encoding byte))
$component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select * from SMS_SCI_ClientComp where FileType=2 and ItemName='SoftwareCenter' and ItemType='Client Component' and SiteCode='$SiteCode'"
$component.get()
$props = $component.Props

$prop = $props | where {$_.PropertyName -eq 'SC_Old_Branding'}
$prop.Value = 1 
$prop.Value1 = 'REG_DWORD'
$component.Props = $props

$SettingsXML = [xml]@"
<settings>
  <settings-version>1.0</settings-version>
  <tab-visibility>
    <tab name="AvailableSoftware" visible="true" />
    <tab name="Updates" visible="true" />
    <tab name="OSD" visible="true" />
    <tab name="InstallationStatus" visible="true" />
    <tab name="Compliance" visible="true" />
    <tab name="Options" visible="true" />
  </tab-visibility>
  <software-list>
    <unapproved-applications-hidden>false</unapproved-applications-hidden>
    <installed-applications-hidden>false</installed-applications-hidden>
  </software-list>
  <brand-logo>$Encoded</brand-logo>
  <brand-orgname>Training Lab</brand-orgname>
  <brand-color />
  <application-catalog-link-hidden>false</application-catalog-link-hidden>
</settings>
"@

$prop = $props | where {$_.PropertyName -eq 'SettingsXml'}
$prop.Value = 0
$prop.Value2 = $SettingsXML.OuterXml
$component.Props = $props

$prop = $props | where {$_.PropertyName -eq 'SCLogo'}
$prop.Value = 0
$component.Props = $props

$component.Put() | Out-Null

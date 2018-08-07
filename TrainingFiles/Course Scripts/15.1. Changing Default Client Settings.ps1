$Classes = @()
$Classes += New-CMInventoryReportClass -id 'MICROSOFT|SERVICE|1.0' -ReportProperty @('DisplayName','Name','PathName','ServiceType','StartMode','StartName','Status','State')
$Classes += New-CMInventoryReportClass -id 'MICROSOFT|LOGICAL_DISK|1.0' -ReportProperty @('Availability','Caption','Compressed','Description','DeviceID','DriveType','FileSystem','FreeSpace','Name','Purpose','Size','Status','StatusInfo','SystemName','VolumeName','VolumeSerialNumber','FreeSpace')
$Classes += New-CMInventoryReportClass -id 'MICROSOFT|ENVIRONMENT|1.0' -ReportProperty @('Name','UserName','Caption','Description','InstallDate','Status','SystemVariable','VariableValue')

Set-CMClientSettingHardwareInventory -DefaultSetting -AddInventoryReportClass @($classes)
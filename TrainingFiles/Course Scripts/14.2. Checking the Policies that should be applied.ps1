$DeviceList = get-cmdevice -Fast | where-object {$_.DeviceOS -like 'Microsoft Windows NT Workstation 10.0*'}
Get-CMResultantSettings -Name ($DeviceList[0].Name) -SettingsType Device
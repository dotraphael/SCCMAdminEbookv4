$ClientSettingsName = "Remote Control for Windows 10"
New-CMClientSetting -Name "$ClientSettingsName" -Type Device

Set-CMClientSetting -Name "$ClientSettingsName" -RemoteToolsSettings -AccessLevel FullControl -AllowPermittedViewersToRemoteDesktop $True -AllowRemoteControlOfUnattendedComputer $True -AudibleSignal PlayNoSound -FirewallExceptionProfile Domain -ManageRemoteDesktopSetting $True -ManageSolicitedRemoteAssistance $True -ManageUnsolicitedRemoteAssistance $True -PermittedViewer "CLASSROOM\SCCM Remote Tools" -RemoteAssistanceAccessLevel FullControl -RequireAuthentication $False -PromptUserForPermission $True
Start-CMClientSettingDeployment -ClientSettingName "$ClientSettingsName" -CollectionName "Windows 10 Workstations"

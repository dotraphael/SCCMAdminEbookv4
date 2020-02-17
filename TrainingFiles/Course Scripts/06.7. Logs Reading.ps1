Copy-Item '\\srv0001\Trainingfiles\Source\MECMCB\Extract\SMSSETUP\TOOLS\CMTrace.exe' 'C:\windows\cmtrace.exe'
$executecmtrace = "`"$($env:windir)\CMTrace.exe`" `"%1`""

New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
New-Item -Path "hkcr:Local Settings\Software\Microsoft\Windows\Shell\MuiCache" -Force | Out-Null
Set-ItemProperty -Path "hkcr:Local Settings\Software\Microsoft\Windows\Shell\MuiCache" -Name ($env:windir + '\CMTrace.exe') -Value 'Configuration Manager Trace Log Tool' | Out-Null
New-Item -Path "hkcr:.lo_" -Force | Out-Null
Set-ItemProperty -Path "hkcr:.lo_" -Name '(Default)' -Value 'Log.File' | Out-Null
    
New-Item -Path "hkcr:.log" -Force | Out-Null
Set-ItemProperty -Path "hkcr:.log" -Name '(Default)' -Value 'Log.File' | Out-Null
    
New-Item -Path "hkcr:Log.File" -Force | Out-Null
New-Item -Path "hkcr:Log.File\Shell" -Force | Out-Null
New-Item -Path "hkcr:Log.File\Shell\Open" -Force | Out-Null
New-Item -Path "hkcr:Log.File\Shell\Open\Command" -Force | Out-Null
Set-ItemProperty -Path "hkcr:\Log.File\shell\open\command" -Name '(Default)' -Value $executecmtrace | Out-Null
    
New-Item -Path "hkcu:Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" -Force | Out-Null
Set-ItemProperty -Path "hkcu:Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" -Name ($env:windir + '\CMTrace.exe') -Value 'Configuration Manager Trace Log Tool' | Out-Null
New-Item -Path "hkcu:Software\Classes\.lo_" -Force | Out-Null
Set-ItemProperty -Path "hkcu:Software\Classes\.lo_" -Name '(Default)' -Value 'Log.File' | Out-Null
    
New-Item -Path "hkcu:Software\Classes\.log" -Force | Out-Null
Set-ItemProperty -Path "hkcu:Software\Classes\.log" -Name '(Default)' -Value 'Log.File' | Out-Null
    
New-Item -Path "hkcu:Software\Classes\Log.File" -Force | Out-Null
New-Item -Path "hkcu:Software\Classes\Log.File\Shell" -Force | Out-Null
New-Item -Path "hkcu:Software\Classes\Log.File\Shell\Open" -Force | Out-Null
New-Item -Path "hkcu:Software\Classes\Log.File\Shell\Open\Command" -Force | Out-Null
Set-ItemProperty -Path "hkcu:Software\Classes\Log.File\shell\open\command" -Name '(Default)' -Value $executecmtrace | Out-Null

Start-Process -Filepath ('C:\windows\cmtrace.exe')
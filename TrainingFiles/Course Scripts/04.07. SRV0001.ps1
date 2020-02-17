Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name AUOptions -Value 1

Start-Process -Filepath ("slmgr") -ArgumentList ("/ato") -wait -NoNewWindow
Start-sleep 10
Start-Process -Filepath ("netsh") -ArgumentList ('interface ip set address "Ethernet" dhcp') -wait -NoNewWindow
Start-Process -Filepath ("netsh") -ArgumentList ('interface ip set dns "Ethernet" dhcp') -wait -NoNewWindow

Add-MpPreference -ThreatIDDefaultAction_Ids @(2147519003) -ThreatIDDefaultAction_Actions Allow

#install DC, machine will restart
Cd \TrainingFiles\Scripts
.\SRV0001-01-InstallDC.ps1

#once the machine restart, configure the DC
Cd \TrainingFiles\Scripts
.\SRV0001-02-ConfigureDC.ps1

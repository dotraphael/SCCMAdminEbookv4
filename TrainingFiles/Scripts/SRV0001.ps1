Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name AUOptions -Value 1

Start-Process -Filepath ("slmgr") -ArgumentList ("/ato") –wait -NoNewWindow
Start-sleep 10
Start-Process -Filepath ("netsh") -ArgumentList ('interface ip set address "Ethernet" dhcp') –wait -NoNewWindow
Start-Process -Filepath ("netsh") -ArgumentList ('interface ip set dns "Ethernet" dhcp') –wait -NoNewWindow

Add-MpPreference -ThreatIDDefaultAction_Ids @(2147519003) -ThreatIDDefaultAction_Actions Allow

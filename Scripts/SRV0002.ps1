Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name AUOptions -Value 1

#Activate Server with its trial version
Start-Process -Filepath ("slmgr") -ArgumentList ("/ato") –wait
Start-sleep 10

#Add SCCM Admins to Administrators
Start-Process -Filepath ("NET") -ArgumentList ('LOCALGROUP "Administrators" /ADD "CLASSROOM\SCCM Admins"') –wait

#Add SCCM Admins to Administrators
Start-Process -Filepath ("NET") -ArgumentList ('LOCALGROUP "Administrators" /ADD "CLASSROOM\Workstation Admins"') –wait

#Shutdown server
Start-Process -Filepath ("shutdown") -ArgumentList ("/s /t 0")

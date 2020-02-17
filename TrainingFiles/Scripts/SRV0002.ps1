Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name AUOptions -Value 1

#Activate Server with its trial version
Start-Process -Filepath ("slmgr") -ArgumentList ("/ato") –wait -NoNewWindow
Start-sleep 10

#Add MECM Admins to Administrators
Start-Process -Filepath ("NET") -ArgumentList ('LOCALGROUP "Administrators" /ADD "CLASSROOM\MECM Admins"') –wait

#to be validated
#Add Workstation Admins to Administrators
#Start-Process -Filepath ("NET") -ArgumentList ('LOCALGROUP "Administrators" /ADD "CLASSROOM\Workstation Admins"') –wait

#Shutdown server
Start-Process -Filepath ("shutdown") -ArgumentList ("/s /t 0")

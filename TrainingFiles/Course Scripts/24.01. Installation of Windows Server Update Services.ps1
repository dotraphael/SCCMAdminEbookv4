#using SQL Server Installed on the same box
Get-WindowsFeature -Name UpdateServices-Services,UpdateServices-DB | Install-WindowsFeature -IncludeManagementTools 
Start-Process -Filepath ('C:\Program Files\Update Services\Tools\WsusUtil.exe') -ArgumentList ('PostInstall CONTENT_DIR="C:\WSUS" SQL_INSTANCE_NAME="srv0002"') -wait  -NoNewWindow

#using Windows Internal Database (WID)
#Get-WindowsFeature -Name UpdateServices | Install-WindowsFeature -IncludeManagementTools 
#Start-Process -Filepath ('C:\Program Files\Update Services\Tools\WsusUtil.exe') -ArgumentList ('PostInstall CONTENT_DIR="C:\WSUS"') -wait  -NoNewWindow

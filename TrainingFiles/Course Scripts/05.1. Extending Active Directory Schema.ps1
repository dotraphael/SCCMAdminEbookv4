#Extend Schema
Start-Process -Filepath ('C:\trainingfiles\Source\MECMCB\Extract\SMSSETUP\BIN\X64\extadsch.exe') -wait -NoNewWindow
Start-Sleep 30

#Confirm Schema Extension
$schema = [DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetCurrentSchema()
start-sleep 15
$schema.RefreshSchema()
$schema.FindClass("mSSMSSite")

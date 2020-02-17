$inifile = @"
[Identification]
Action=RecoverPrimarySite

CDLatest=1

[Options]
ProductID=EVAL
SiteCode=001
SiteName=Training Lab
SMSInstallDir=c:\ConfigMgr
SDKServer=SRV0002.classroom.intranet
PrerequisiteComp=0
PrerequisitePath=C:\trainingfiles
AdminConsole=0
JoinCEIP=0

[SQLConfigOptions]
SQLServerName=SRV0002.classroom.intranet
SQLServerPort=1433
DatabaseName=CM_001
SQLSSBPort=4022
SQLDataFilePath=C:\SQLServer\MSSQL14.MSSQLSERVER\MSSQL\DATA\
SQLLogFilePath=C:\SQLServer\MSSQL14.MSSQLSERVER\MSSQL\DATA\

[CloudConnectorOptions]
CloudConnector=0
CloudConnectorServer=
UseProxy=0
ProxyName=
ProxyPort=

[SystemCenterOptions]
SysCenterId=nu8ZfCX5X5nhqqqlnJBaqIP6l50bxWjylWL/Q0Pl5vQ=

[HierarchyExpansionOption]

[RecoveryOptions]
ServerRecoveryOptions=4
DatabaseRecoveryOptions=10
BackupLocation=\\srv0001\MECMBackup\001Backup\
"@

$inifile -replace "`n", "`r`n"| Out-File -FilePath "\\srv0001\TempFiles\restorecmcb.ini"

Start-Process -Filepath ("\\srv0001\MECMBackup\001Backup\CD.Latest\SMSSETUP\BIN\X64\setup.exe") -ArgumentList ('/script "\\srv0001\TempFiles\restorecmcb.ini"') -wait -NoNewWindow

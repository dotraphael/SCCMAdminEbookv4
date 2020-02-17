$wmiName = (Get-WmiObject –namespace root\Microsoft\SqlServer\ReportServer  –class __Namespace).Name
$rsConfig = Get-WmiObject –namespace "root\Microsoft\SqlServer\ReportServer\$wmiName\v14\Admin" -class MSReportServer_ConfigurationSetting -filter "InstanceName='SSRS'"
import-module "C:\SQLServer (x86)\140\Tools\PowerShell\Modules\SQLPS\SQLPS.psd1" -Force
start-sleep 5

##create database
$SQLScript = ($rsConfig.GenerateDatabaseCreationScript('ReportServer', 1033, $false)).Script
Invoke-Sqlcmd -ServerInstance 'srv0002' -Query $SQLScript

##add rights
$SQLScript = ($rsConfig.GenerateDatabaseRightsScript('classroom\mecmadmin', 'ReportServer', $false, $true)).Script
Invoke-Sqlcmd -ServerInstance 'srv0002' -Query $SQLScript

$rsConfig.SetDatabaseConnection('SRV0002', 'ReportServer', 0, 'classroom\mecmadmin','Pa$$w0rd')
$rsConfig.RemoveURL('ReportServerWebService', 'http://+:80', 1033)
$rsconfig.SetVirtualDirectory('ReportServerWebService', 'ReportServer', 1033)
$rsConfig.ReserveURL('ReportServerWebService', 'http://+:80', 1033)

$rsConfig.RemoveURL('ReportServerWebApp', 'http://+:80', 1033)
$rsconfig.SetVirtualDirectory('ReportServerWebApp','Reports',1033)
$rsConfig.ReserveURL('ReportServerWebApp', 'http://+:80', 1033)

$rsConfig.SetServiceState($true, $true, $true)
$rsConfig.InitializeReportServer($rsConfig.InstallationID)

Get-Service -Name SQLServerReportingServices | Restart-Service
start-sleep 30

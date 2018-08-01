$Server="SRV0002"
$db = "ReportServer"
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null
$SMOserver = New-Object ('Microsoft.SqlServer.Management.Smo.Server') -argumentlist $Server
$SMOserver.Databases["$db"] | select Name, RecoveryModel | Format-Table
$SMOserver.databases["$db"].recoverymodel = "Simple"
$SMOserver.databases["$db"].alter()
$SMOserver.Databases["$db"] | select Name, RecoveryModel | Format-Table

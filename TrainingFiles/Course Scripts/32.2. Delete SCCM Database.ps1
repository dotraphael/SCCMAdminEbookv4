$Server="SRV0002.classroom.intranet" 
$dbName="CM_001"

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null
$SMOserver = New-Object ('Microsoft.SqlServer.Management.Smo.Server') -argumentlist $Server
$SMOserver.Databases | select Name, Size,DataSpaceUsage, IndexSpaceUsage, SpaceAva
if ($SMOserver.Databases[$dbName] -ne $null) {
	$smoserver.KillAllProcesses($dbname)
	$smoserver.databases[$dbname].drop()
} 

$maxMem = 4096
$minMem = 4096

[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
$srv = new-object Microsoft.SQLServer.Management.Smo.Server($SQLInstanceName)
$srv.ConnectionContext.LoginSecure = $true

$srv.Configuration.MaxServerMemory.ConfigValue = $maxMem
$srv.Configuration.MinServerMemory.ConfigValue = $minMem

$srv.Configuration.Alter()

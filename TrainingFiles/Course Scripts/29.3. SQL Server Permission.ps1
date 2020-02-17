$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=SRV0002;Initial Catalog=CM_$($SiteCode)_DW;trusted_connection = true;"
$conn.Open()

$SqlCommand = $Conn.CreateCommand()
$SqlCommand.CommandTimeOut = 0
$SqlCommand.CommandText = "create user [CLASSROOM\svc_ssrsea] from login [CLASSROOM\svc_ssrsea]"
$SqlCommand.ExecuteNonQuery()
Start-Sleep 5
$SqlCommand.CommandText = "EXEC sp_addrolemember 'db_datareader', 'CLASSROOM\svc_ssrsea'"
$SqlCommand.ExecuteNonQuery()

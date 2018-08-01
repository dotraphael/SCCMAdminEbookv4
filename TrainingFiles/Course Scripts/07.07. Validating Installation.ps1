$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=SRV0002;Initial Catalog=Master;trusted_connection = true;"
$conn.Open()

$SqlCommand = $Conn.CreateCommand()
$SqlCommand.CommandTimeOut = 0
$SqlCommand.CommandText = "select @@version"
$DataAdapter = new-object System.Data.SqlClient.SqlDataAdapter $SqlCommand
$dataset = new-object System.Data.Dataset
$DataAdapter.Fill($dataset)

$SqlCommand2 = $Conn.CreateCommand()
$SqlCommand2.CommandTimeOut = 0
$SqlCommand2.CommandText = "SELECT SERVERPROPERTY ('productversion'),SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')"
$DataAdapter2 = new-object System.Data.SqlClient.SqlDataAdapter $SqlCommand2
$dataset2 = new-object System.Data.Dataset
$DataAdapter2.Fill($dataset2)

$dataset.Tables[0] | select Column1
$dataset2.Tables[0] | select Column1,Column2,Column3

$conn.close()


$web = New-Object -ComObject msxml2.xmlhttp
$url = @("http://localhost:80/reports", "http://localhost:80/reportserver")
$url | foreach {
	$item = $_
	Write-host "Checking $item"
	try {   
		$web.open('GET', $item, $false)
		$web.send()
			
		Write-host "HTTP Return $($web.status)"
	} catch {
		Write-host "ERROR: $($_)"
	}
}

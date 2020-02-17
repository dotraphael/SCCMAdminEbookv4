$username = "CLASSROOM\workstationadmin"
$password = 'Pa$$w0rd' | convertto-securestring -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password 

Start-Process "C:\ConfigMgr\AdminConsole\bin\Microsoft.ConfigurationManagement.exe" -Credential $Cred

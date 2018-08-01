New-NetIPAddress –InterfaceAlias "Ethernet" –IPAddress "192.168.3.1" –PrefixLength 24 -DefaultGateway 192.168.3.254
Get-WindowsFeature AD-Domain-Services | Install-WindowsFeature
Import-Module ADDSDeployment
$SecurePassword = 'Pa$$w0rd' | ConvertTo-SecureString -AsPlainText -Force
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainName "classroom.intranet" -DomainNetbiosName "CLASSROOM" -ForestMode "WinThreshold" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword $SecurePassword

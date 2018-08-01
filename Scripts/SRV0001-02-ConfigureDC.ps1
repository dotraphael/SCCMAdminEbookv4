#Create AD Site
New-ADReplicationSite -Name "TrainingLab"

##Create AD Subnet
New-ADReplicationSubnet -Name '192.168.3.0/24' -site 'TrainingLab'
New-ADReplicationSubnet -Name '172.16.254.0/24' -site 'TrainingLab'

##OU Creation
NEW-ADOrganizationalUnit "Classroom"
NEW-ADOrganizationalUnit "Admins" –path "OU=Classroom,DC=Classroom,DC=intranet"
NEW-ADOrganizationalUnit "Groups" –path "OU=Classroom,DC=Classroom,DC=intranet"
NEW-ADOrganizationalUnit "Servers" –path "OU=Classroom,DC=Classroom,DC=intranet"
NEW-ADOrganizationalUnit "SCCM" –path "OU=Servers,OU=Classroom,DC=Classroom,DC=intranet"
NEW-ADOrganizationalUnit "Service Accounts" –path "OU=Classroom,DC=Classroom,DC=intranet"
NEW-ADOrganizationalUnit "Users" –path "OU=Classroom,DC=Classroom,DC=intranet"
NEW-ADOrganizationalUnit "Workstations" –path "OU=Classroom,DC=Classroom,DC=intranet"
NEW-ADOrganizationalUnit "Enabled" –path "OU=Workstations,OU=Classroom,DC=Classroom,DC=intranet"
NEW-ADOrganizationalUnit "Disabled" –path "OU=Workstations,OU=Classroom,DC=Classroom,DC=intranet"

##Admin Account Creation
$SecurePassword = 'Pa$$w0rd' | ConvertTo-SecureString -AsPlainText -Force
New-ADUser -Name sccmadmin -AccountPassword $SecurePassword -Description "SCCMAdmin" -DisplayName "SCCMAdmin" -UserPrincipalName "sccmadmin@classroom.intranet" -PasswordNeverExpires $true -Path "OU=Admins,OU=classroom,dc=classroom,dc=intranet" -Enabled $true
New-ADUser -Name workstationadmin -AccountPassword $SecurePassword -Description "WorkstationAdmin" -DisplayName "WorkstationAdmin" -UserPrincipalName "WorkstationAdmin@classroom.intranet"  -PasswordNeverExpires $true -Path "OU=Admins,OU=classroom,dc=classroom,dc=intranet" -Enabled $true

##Group creation
New-ADGroup -GroupScope Global -GroupCategory Security -Name "SCCM Admins" -Path "OU=Groups,OU=classroom,dc=classroom,dc=intranet"
New-ADGroup -GroupScope Global -GroupCategory Security -Name "SCCM Mobile Device Users" -Path "OU=Groups,OU=classroom,dc=classroom,dc=intranet"
New-ADGroup -GroupScope Global -GroupCategory Security -Name "SCCM remote Tools" -Path "OU=Groups,OU=classroom,dc=classroom,dc=intranet"
New-ADGroup -GroupScope Global -GroupCategory Security -Name "SCCM Servers" -Path "OU=Groups,OU=classroom,dc=classroom,dc=intranet"
New-ADGroup -GroupScope Global -GroupCategory Security -Name "Workstation Admins" -Path "OU=Groups,OU=classroom,dc=classroom,dc=intranet"

##Service Account Creation
New-ADUser -Name svc_sccmna -AccountPassword $SecurePassword -Description "svc_sccmna" -DisplayName "svc_sccmna" -UserPrincipalName "svc_sccmna@classroom.intranet" -PasswordNeverExpires $true -Path "OU=Service Accounts,OU=classroom,dc=classroom,dc=intranet" -Enabled $true
New-ADUser -Name svc_sccmpush -AccountPassword $SecurePassword -Description "svc_sccmpush" -DisplayName "svc_sccmpush" -UserPrincipalName "svc_sccmpush@classroom.intranet" -PasswordNeverExpires $true -Path "OU=Service Accounts,OU=classroom,dc=classroom,dc=intranet" -Enabled $true
New-ADUser -Name svc_ssrsea -AccountPassword $SecurePassword -Description "svc_ssrsea" -DisplayName "svc_ssrsea" -UserPrincipalName "svc_ssrsea@classroom.intranet" -PasswordNeverExpires $true -Path "OU=Service Accounts,OU=classroom,dc=classroom,dc=intranet" -Enabled $true
New-ADUser -Name svc_sccmjoin -AccountPassword $SecurePassword -Description "svc_sccmjoin" -DisplayName "svc_sccmjoin" -UserPrincipalName "svc_sccmjoin@classroom.intranet" -PasswordNeverExpires $true -Path "OU=Service Accounts,OU=classroom,dc=classroom,dc=intranet" -Enabled $true

##User creation
New-ADUser -Name User01 -AccountPassword $SecurePassword -Description "User01" -DisplayName "User01" -UserPrincipalName "User01@classroom.intranet" -PasswordNeverExpires $true -Path "OU=Users,OU=classroom,dc=classroom,dc=intranet" -Enabled $true
New-ADUser -Name User02 -AccountPassword $SecurePassword -Description "User02" -DisplayName "User02" -UserPrincipalName "User02@classroom.intranet" -PasswordNeverExpires $true -Path "OU=Users,OU=classroom,dc=classroom,dc=intranet" -Enabled $true

#Set User Extra Properties
set-aduser User01 -Office 'User1 Office' -Department 'User1 Department'
set-aduser User02 -Office 'User2 Office' -Department 'User2 Department'

#configure Administrator to not expire
set-aduser Administrator -PasswordNeverExpires $true

##Computer Account Creation
New-ADComputer -Name "SRV0002" -SamAccountName "SRV0002" -Path "OU=SCCM,OU=Servers,OU=classroom,dc=classroom,dc=intranet"
New-ADComputer -Name "WKS0001" -SamAccountName "WKS0001" -Path "OU=Enabled,OU=Workstations,OU=classroom,dc=classroom,dc=intranet"
New-ADComputer -Name "WKS0002" -SamAccountName "WKS0002" -Path "OU=Enabled,OU=Workstations,OU=classroom,dc=classroom,dc=intranet"

##Group Population
$server = Get-ADComputer "CN=SRV0002,OU=SCCM,OU=Servers,OU=classroom,dc=classroom,dc=intranet"
$group = Get-ADGroup "CN=SCCM Servers,OU=Groups,OU=classroom,dc=classroom,dc=intranet"
Add-ADGroupMember $group -Members $server

$user = Get-ADUser "CN=sccmadmin,OU=Admins,OU=classroom,dc=classroom,dc=intranet"
$group = Get-ADGroup "CN=SCCM Admins,OU=Groups,OU=classroom,dc=classroom,dc=intranet"
Add-ADGroupMember $group -Members $user

$user = Get-ADUser "CN=sccmadmin,OU=Admins,OU=classroom,dc=classroom,dc=intranet"
$group = Get-ADGroup "CN=SCCM remote Tools,OU=Groups,OU=classroom,dc=classroom,dc=intranet"
Add-ADGroupMember $group -Members $user

$user = Get-ADUser "CN=workstationadmin,OU=Admins,OU=classroom,dc=classroom,dc=intranet"
$group = Get-ADGroup "CN=Workstation Admins,OU=Groups,OU=classroom,dc=classroom,dc=intranet"
Add-ADGroupMember $group –Members $user

$user = Get-ADUser "CN=svc_sccmpush,OU=Service Accounts,OU=classroom,dc=classroom,dc=intranet"
$group = Get-ADGroup "CN=Workstation Admins,OU=Groups,OU=classroom,dc=classroom,dc=intranet"
Add-ADGroupMember $group –Members $user

$user = Get-ADUser "CN=user02,OU=Users,OU=classroom,dc=classroom,dc=intranet"
$group = Get-ADGroup "CN=SCCM Mobile Device Users,OU=Groups,OU=classroom,dc=classroom,dc=intranet"
Add-ADGroupMember $group –Members $user

##Security configuration for the Join Account
Import-Module ActiveDirectory
$root = (Get-ADRootDSE).defaultNamingContext

$objUser = Get-ADUser "CN=svc_sccmjoin,OU=Service Accounts,OU=classroom,dc=classroom,dc=intranet"
$objectComputerguid = new-object Guid bf967a86-0de6-11d0-a285-00aa003049e2
$acl = get-acl "ad:$root"
                
$ace1 = new-object System.DirectoryServices.ActiveDirectoryAccessRule $objUser.SID, "CreateChild, DeleteChild", "Allow", $objectComputerguid, "SelfAndChildren"
$acl.AddAccessRule($ace1)
                
$objectExtendedRightGUID = new-object Guid bf967a86-0de6-11d0-a285-00aa003049e2
$ace2 = new-object System.DirectoryServices.ActiveDirectoryAccessRule $objUser.SID, "ReadProperty, WriteProperty, ReadControl, WriteDacl", "Allow", "Descendents", $objectExtendedRightGUID
$acl.AddAccessRule($ace2)
               
$objectExtendedRightGUID2 = new-object Guid 00299570-246d-11d0-a768-00aa006e0529
$ace3 = new-object System.DirectoryServices.ActiveDirectoryAccessRule $objUser.SID,"ExtendedRight", "Allow", $objectExtendedRightGUID2, "Descendents", $objectComputerguid
$acl.AddAccessRule($ace3) 
                
$objectExtendedRightGUID3 = new-object Guid ab721a53-1e2f-11d0-9819-00aa0040529b
$ace4 = new-object System.DirectoryServices.ActiveDirectoryAccessRule $objUser.SID,"ExtendedRight", "Allow", $objectExtendedRightGUID3, "Descendents", $objectComputerguid
$acl.AddAccessRule($ace4) 
                
$objectExtendedRightGUID4 = new-object Guid 72e39547-7b18-11d1-adef-00c04fd8d5cd
$ace5 = new-object System.DirectoryServices.ActiveDirectoryAccessRule $objUser.SID,"Self", "Allow", $objectExtendedRightGUID4, "Descendents", $objectComputerguid
$acl.AddAccessRule($ace5) 

$objectExtendedRightGUID5 = new-object Guid f3a64788-5306-11d1-a9c5-0000f80367c1
$ace6 = new-object System.DirectoryServices.ActiveDirectoryAccessRule $objUser.SID,"Self", "Allow", $objectExtendedRightGUID5, "Descendents", $objectComputerguid
$acl.AddAccessRule($ace6)
                
Set-acl -aclobject $acl "ad:$root" 

##Import GPO
Import-GPO -BackupId C798C128-9583-43FA-AD98-B0622903F68A -Path "c:\TrainingFiles\GPO" -TargetName "Disable BITS" -CreateIfNeeded
New-gplink -name "Disable BITS" -target "OU=Disabled,OU=Workstations,OU=Classroom,DC=Classroom,DC=intranet"

$wagroup = get-adgroup "Workstation Admins"
$dagroup = get-adgroup "Domain Admins"
$dugroup = get-adgroup "Domain Users"
$xml = gc "c:\TrainingFiles\GPO\{6528DE3A-B3EF-4713-8AFC-E56628C48C2A}\gpreport.xml"  
$xml = $xml -replace "S-1-5-21-3656108786-1635578000-2511985611-513", $dugroup.SID.Value
$xml = $xml -replace "S-1-5-21-3656108786-1635578000-2511985611-1109", $wagroup.SID.Value
$xml = $xml -replace "S-1-5-21-3656108786-1635578000-2511985611-512", $dagroup.SID.Value
$xml | out-file "c:\TrainingFiles\GPO\{6528DE3A-B3EF-4713-8AFC-E56628C48C2A}\gpreport.xml" -force

$inf = gc "c:\TrainingFiles\GPO\{6528DE3A-B3EF-4713-8AFC-E56628C48C2A}\DomainSysvol\GPO\Machine\microsoft\windows nt\SecEdit\GptTmpl.inf"
$inf = $inf -replace "S-1-5-21-3656108786-1635578000-2511985611-513", $dugroup.SID.Value
$inf = $inf -replace 'S-1-5-21-3656108786-1635578000-2511985611-1109', $wagroup.SID.Value
$inf = $inf -replace 'S-1-5-21-3656108786-1635578000-2511985611-512', $dagroup.SID.Value
$inf | out-file "c:\TrainingFiles\GPO\{6528DE3A-B3EF-4713-8AFC-E56628C48C2A}\DomainSysvol\GPO\Machine\microsoft\windows nt\SecEdit\GptTmpl.inf" -force

Import-GPO -BackupId 6528DE3A-B3EF-4713-8AFC-E56628C48C2A -Path "c:\TrainingFiles\GPO" -TargetName "Workstation Local Administrators" -CreateIfNeeded
New-gplink -name "Workstation Local Administrators" -target "OU=Workstations,OU=Classroom,DC=Classroom,DC=intranet"

Import-GPO -BackupId 6C687436-F64F-451F-8A4E-80F156719D31 -Path "c:\TrainingFiles\GPO" -TargetName "Workstation Local Firewall" -CreateIfNeeded
New-gplink -name "Workstation Local Firewall" -target "OU=Workstations,OU=Classroom,DC=Classroom,DC=intranet"

##Create TrainingFiles share
New-SmbShare -Name TrainingFiles -Path c:\TrainingFiles -ReadAccess Everyone

##Create TempFiles share
New-Item c:\TempFiles -type directory
New-SmbShare -Name TempFiles -Path c:\TempFiles -FullAccess Everyone

##Create WSUSDownloadContent folder 
New-Item "c:\wsusdownloadcontent" -ItemType Directory

##Set NTFS Rights on WSUSDownloadContent folder 
$Acl = Get-Acl "c:\wsusdownloadcontent"
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("Everyone","FullControl","ContainerInherit, ObjectInherit", "None", "Allow")
$Acl.SetAccessRule($Ar)
Set-Acl "c:\wsusdownloadcontent" $Acl

##Create WSUSDownloadContent Share
New-SmbShare -Name "WSUSDownloadContent" -Path "c:\WSUSDownloadContent" -FullAccess Everyone

##Create SCCMBackup folder 
New-Item "c:\SCCMBackup" -ItemType Directory

##Set NTFS Rights on SCCMBackup folder 
$Acl = Get-Acl "c:\SCCMBackup"
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("Everyone","FullControl","ContainerInherit, ObjectInherit", "None", "Allow")
$Acl.SetAccessRule($Ar)
Set-Acl "c:\SCCMBackup" $Acl

##Create SCCMBackup Share
New-SmbShare -Name "SCCMBackup" -Path "c:\SCCMBackup" -FullAccess Everyone

##DHCP Installation and Configuration
Get-WindowsFeature DHCP | Install-WindowsFeature
netsh dhcp add securitygroups
Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias "Ethernet"
Add-DhcpServerInDC -DnsName "SRV0001.classroom.intranet"
Restart-service dhcpserver

Add-DhcpServerv4Scope -Name "Classroom" -StartRange 192.168.3.100 -EndRange 192.168.3.200 -SubnetMask 255.255.255.0
Set-DhcpServerv4OptionValue -OptionId 3 -value 192.168.3.254
Set-DhcpServerv4OptionValue -OptionId 6 -value 192.168.3.1
Set-DhcpServerv4OptionValue -OptionId 15 -value "classroom.intranet"
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2

##Install Certificate authority
Install-WindowsFeature Adcs-cert-Authority
Install-AdcsCertificationAuthority -CAType EnterpriseRootCa -CACommonName "Classroom Root CA" -KeyLength 2048 -HashAlgorithmName SHA256 -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" -ValidityPeriod Years -ValidityPeriodUnits 40 -Force

##RSAT Tools Installation for for DHCP, AD, DNS, PKI
Get-WindowsFeature RSAT-DHCP | Install-WindowsFeature 
Get-WindowsFeature RSAT-ADDS | Install-WindowsFeature
Get-WindowsFeature RSAT-AD-AdminCenter | Install-WindowsFeature
Get-WindowsFeature RSAT-ADDS-Tools | Install-WindowsFeature
Get-WindowsFeature RSAT-ADCS-Mgmt | Install-WindowsFeature

#Remove any DNS Forward
$IPAddress = (Get-DnsServerForwarder).IPAddress 
if ($IPAddress -ne $null) { $IPAddress | foreach { Remove-DnsServerForwarder -IPAddress $_.IPAddressToString -Force } }

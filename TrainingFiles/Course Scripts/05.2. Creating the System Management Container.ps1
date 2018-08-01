Import-Module ActiveDirectory
$root = (Get-ADRootDSE).defaultNamingContext

if (!([adsi]::Exists("LDAP://CN=System Management,CN=System,$root"))) {
    $smcontainer = New-ADObject -Type Container -name "System Management" -Path "CN=System,$root" -Passthru
}

$acl = get-acl "ad:CN=System Management,CN=System,$root"

$objGroup = Get-ADGroup -filter {Name -eq "SCCM Servers"}
$All = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::SelfAndChildren
$ace = new-object System.DirectoryServices.ActiveDirectoryAccessRule $objGroup.SID, "GenericAll", "Allow", $All
$acl.AddAccessRule($ace) 
Set-acl -aclobject $acl "ad:CN=System Management,CN=System,$root"
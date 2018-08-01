#Step 12, 13 and 14 only
$ModulePath = $env:SMS_ADMIN_UI_PATH
if ($ModulePath -eq $null) {
	$ModulePath = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment").SMS_ADMIN_UI_PATH
}

$ModulePath = $ModulePath.Replace("bin\i386","bin\ConfigurationManager.psd1")

$Certificate = Get-AuthenticodeSignature -FilePath "$ModulePath" -ErrorAction SilentlyContinue
$CertStore = New-Object System.Security.Cryptography.X509Certificates.X509Store("TrustedPublisher")
$CertStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::MaxAllowed)
$Certexist = ($CertStore.Certificates | where {$_.thumbprint -eq $Certificate.SignerCertificate.Thumbprint}) -ne $null

if ($Certexist -eq $false) {
    $CertStore.Add($Certificate.SignerCertificate)
}

$CertStore.Close()

import-module $ModulePath -force

Get-Module -Name ConfigurationManager | select Version 
Remove-Module ConfigurationManager -Force
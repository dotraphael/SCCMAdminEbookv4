$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
$mecmversion = '1910'

while ($true) {
	$SiteUpdate = Get-CMSiteUpdate -Name "Configuration Manager $($mecmversion)" -Fast | where {$_.UpdateType -eq 0}
	if ($SiteUpdate -ne $null) {
		if ($SiteUpdate.State -ne 131074) {
			Write-Host "Pre-Check is still happening..."
			Start-Sleep 30
		} else {
			Write-Host "Pre-Req done, starting update"
			Install-CMSiteUpdate -Name $SiteUpdate.Name
			Get-Process -Name Microsoft.ConfigurationManagement | Stop-Process
			break
		}
	}
}

while ($true) {
	$SiteUpdate = Get-CMSiteUpdate -Name "Configuration Manager $($mecmversion)" -Fast | where {$_.UpdateType -eq 0}
	if ($SiteUpdate -ne $null) {
		if ($SiteUpdate.State -ne 196612) {
			Write-Host "Installation is still happening..."
			Start-Sleep 30
		} else {
			Write-Host "Installation done, upgrading MECM Console"
			$InstallationFolder = (Get-ItemProperty -Path "hklm:Software\Wow6432Node\Microsoft\ConfigMgr10\Setup" -ErrorAction SilentlyContinue)."UI Installation Directory"
			$Connection = (Get-ItemProperty -Path "hklm:Software\Wow6432Node\Microsoft\ConfigMgr10\AdminUI\Connection" -ErrorAction SilentlyContinue)."Server"
			if ($InstallationFolder -eq $null) {
				$InstallationFolder = "C:\ConfigMgr\AdminConsole"
			}
			if ($InstallationFolder.Substring($InstallationFolder.Length-1) -eq '\') {
				$InstallationFolder = $InstallationFolder.Substring(0, $InstallationFolder.Length-1)
			}
			if ($Connection -eq $null) {
				$Connection = $servername
			}
			cd c:
			Remove-Module ConfigurationManager -Force

			Start-Process -Filepath ("C:\ConfigMgr\EasySetupPayload\$(($SiteUpdate | select PackageGuid).PackageGuid)\SMSSETUP\BIN\I386\consolesetup.exe") -ArgumentList ("/q TargetDir=`"$($InstallationFolder)`" DefaultSiteServerName=$($Connection)") -Wait  -NoNewWindow
			Start-Sleep 5
			Start-Process -Filepath ("C:\ConfigMgr\AdminConsole\bin\Microsoft.ConfigurationManagement.exe")

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
			if ((get-psdrive $SiteCode -erroraction SilentlyContinue | measure).Count -ne 1) {
				new-psdrive -Name $SiteCode -PSProvider "AdminUI.PS.Provider\CMSite" -Root $servername
			}
			cd "$($SiteCode):"
			break
		}
	} else {
		Write-Host "Installation is still happening..."
		Start-Sleep 30
	}
}
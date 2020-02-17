$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

$ModulePath = $env:SMS_ADMIN_UI_PATH
if ($ModulePath -eq $null) {
	$ModulePath = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment").SMS_ADMIN_UI_PATH
}
$ModulePath += "\CmRcViewer.exe"

$device = Get-CMDevice -Name "WKS0001"
if ($Device.IsClient -eq $true) { Start-Process -Filepath ("$ModulePath") -ArgumentList ("$($device.Name) \\$($servername)") } else { "Computer is not a MECM Client" }

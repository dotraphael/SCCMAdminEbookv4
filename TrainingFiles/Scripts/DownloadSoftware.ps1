$logpath = "$($env:windir)\temp\DownloadSoftware.ps1.log"
$rootFolder = "E:\CorpVMs\TrainingFilesv4ADM"

##Functions
Function Write-Log {
	PARAM (
		[String]$Message,
		[int]$severity = 1
	)
	$TimeZoneBias = Get-WmiObject -Query "Select Bias from Win32_TimeZone"
	$Date = Get-Date -Format "HH:mm:ss.fff"
	$Date2 = Get-Date -Format "MM-dd-yyyy"

	if (($logpath -ne $null) -and ($logpath -ne '')) {
		"<![LOG[$Message]LOG]!><time=`"$date+$($TimeZoneBias.bias)`" date=`"$date2`" component=`"$component`" context=`"`" type=`"$severity`" thread=`"`" file=`"`">" | Out-File -FilePath $logpath -Append -NoClobber -Encoding default
	}

	switch ($severity) 	{
		3 { Write-Host $Message -ForegroundColor Red }
		2 { Write-Host $Message -ForegroundColor Yellow }
		1 { Write-Host $Message }
	}
}

function Get-File {
	param (
		[string]$URL,
		[string]$Path,
		[string]$FileName
	)
	$FilePath = "$Path\$FileName"

	if (Test-Path $filePath) {
		Write-log -message "file $FilePath already exist, ignoring it" -severity 2
		return
	}

	try	{
		Write-log -message "Downloading $URL to $FilePath" -severity 1
		$WebClient = New-Object System.Net.WebClient
		$WebClient.DownloadFile($URL, $FilePath)
	} catch {
		Write-log -message "Failed to download from [$URL]" -severity 3
		Write-log -message "Error: $_" -severity 3
	}
}

function New-Folder {
	param (
		[string]$FolderPath
	)
	if (!(Test-Path $FolderPath)) {
		Write-log -message "Creating folder $FolderPath" -severity 1
		New-Item ($FolderPath) -type directory -force | out-null
	} else {
		Write-log -message "folder $FolderPath already exist, ignoring it" -severity 2
	}

}

##Variables
$Folders1stLevel = "GPO;Isos;OSCaptured;Scripts;Source;vhdx;AnswerFiles"
$eicarString1 = 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR'
$eicarString2 = '-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'

$downloadFiles = @(
"7-zip;http://www.7-zip.org/a/7z1604-x64.exe;7z1604-x64.exe",
"Silverlight;http://go.microsoft.com/fwlink/?LinkID=229321;Silverlight_x64.exe"
"AdobeXI;ftp://ftp.adobe.com/pub/adobe/reader/win/11.x/11.0.10/en_US/AdbeRdr11010_en_US.exe;AdbeRdr11010_en_US.exe",
"Chrome for Windows;https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B03FE9563-80F9-119F-DA3D-72FBBB94BC26%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable/dl/chrome/install/googlechromestandaloneenterprise64.msi;googlechromestandaloneenterprise64.msi",
"Firefox 49;https://ftp.mozilla.org/pub/firefox/releases/49.0.1/win64/en-US/Firefox%20Setup%2049.0.1.exe;Firefox Setup 49.0.1.exe",
"Firefox 40;https://ftp.mozilla.org/pub/firefox/releases/40.0/win32/en-US/Firefox%20Setup%2040.0.exe;Firefox Setup 40.0.exe",
"Java8;http://javadl.oracle.com/webapps/download/AutoDL?BundleId=211997;Java8.exe",
"Robocopy App-V5 Download;http://bit.ly/17h1rjP;Robocopy App-V5.zip",
"AdkW10Download;https://go.microsoft.com/fwlink/?linkid=2086042;adksetup.exe",
"AdkW10Download;https://go.microsoft.com/fwlink/?linkid=2087112;adkwinpesetup.exe",
"AdkW10Download;https://go.microsoft.com/fwlink/?linkid=2095334;WSIM1903.zip",
"PatchMyPc;https://patchmypc.com/scupcatalog/downloads/publishingservice/PatchMyPC-Publishing-Service.msi;PatchMyPC-Publishing-Service.msi",
"SQLMgmt;https://aka.ms/ssmsfullsetup;SSMS-Setup-ENU.exe",
"MECMCB-Toolkit;https://download.microsoft.com/download/5/0/8/508918E1-3627-4383-B7D8-AA07B3490D21/ConfigMgrTools.msi;ConfigMgrTools.msi",
"MECMCB;http://download.microsoft.com/download/1/B/C/1BCADBD7-47F6-40BB-8B1F-0B2D9B51B289/SC_Configmgr_SCEP_1902.exe;SC_Configmgr_CB.exe",
"SQLServer;https://go.microsoft.com/fwlink/?LinkID=853015;SQLServer2017-SSEI-Eval.exe",
"SQLServer;https://download.microsoft.com/download/C/4/F/C4F908C9-98ED-4E5F-88D5-7D6A5004AEBD/SQLServer2017-KB4515579-x64.exe;SQLServer2017-KB4515579-x64.exe",
"SQLServer;https://download.microsoft.com/download/E/6/4/E6477A2A-9B58-40F7-8AD6-62BB8491EA78/SQLServerReportingServices.exe;SQLServerReportingServices.exe"
)

$downloadIsos = @(
"https://downloads.vyos.io/rolling/current/amd64/vyos-rolling-latest.iso;vyos-rolling-latest.iso",
"http://care.dlservice.microsoft.com/dl/download/B/9/9/B999286E-0A47-406D-8B3D-5B5AD7373A4A/9600.17050.WINBLUE_REFRESH.140317-1640_X64FRE_ENTERPRISE_EVAL_EN-US-IR3_CENA_X64FREE_EN-US_DV9.ISO;W81EE.iso",
"https://software-download.microsoft.com/download/pr/18363.418.191007-0143.19h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-gb.iso;W10EE.iso",
"https://software-download.microsoft.com/download/pr/17763.737.190906-2324.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us_1.iso;WS2019.iso"
)

##Main Script
Write-log -message "Starting Script" -severity 1
Write-log -message "Root Folder is $rootFolder " -severity 1

New-Folder -FolderPath ("$rootFolder")

foreach ($folder in $Folders1stLevel.Split(";")) {
	New-Folder -FolderPath ("$($rootFolder)\$($folder)")
}

foreach ($download in $downloadFiles) {
	$downinfo = $download.split(";")
	New-Folder -FolderPath ("$($rootFolder)\source\$($downinfo[0])")
	Get-File -URL $downinfo[1] -Path ("$($rootFolder)\source\$($downinfo[0])") -FileName ($downinfo[2])
}

foreach ($download in $downloadIsos) {
	$downinfo = $download.split(";")
	Get-File -URL $downinfo[0] -Path ("$($rootFolder)\isos") -FileName ($downinfo[1])
}

##Downloading SQL Server
try {
	if (Test-Path "$($rootFolder)\source\Isos\SQLServer2017-x64-ENU.iso") {
		Write-log -message "Folder $($rootFolder)\source\Isos\SQLServer2017-x64-ENU.iso already exist, ignoring it" -severity 2
	} else {
		Write-log -message "Downloading SQL Server" -severity 1
		Start-Process -Filepath ("$($rootFolder)\source\SQLServer\SQLServer2017-SSEI-Eval.exe") -ArgumentList ("/Action=Download /ENU /MEDIATYPE=ISO /MediaPath=`"$($rootFolder)\Isos`" /QUIET /Language=en-US") -Wait -NoNewWindow
	}
} catch {
	Write-log -message "Error: $_" -severity 3
}

##EICAR AV Exclusion
try {
	Write-log -message "Add EICAR AV exclusion" -severity 1
	Add-MpPreference -ThreatIDDefaultAction_Ids @(2147519003) -ThreatIDDefaultAction_Actions Allow
} catch {
	Write-log -message "Error: $_" -severity 3
}


##Extract robocopy
try {
	if (Test-Path "$($rootFolder)\source\Robocopy App-v5") {
		Write-log -message "Folder $($rootFolder)\source\Robocopy App-v5 already exist, ignoring it" -severity 2
	} else {
		Write-log -message "Extract robocopy" -severity 1
		[System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')
		[System.IO.Compression.ZipFile]::ExtractToDirectory("$($rootFolder)\source\Robocopy App-V5 Download\Robocopy App-v5.zip", "$($rootFolder)\source")
		start-sleep 5
	}
} catch {
	Write-log -message "Error: $_" -severity 3
}

##Create EICAR AV Test File
try {
	if (Test-Path "$($rootFolder)\source\Eicar\eicar test file.txt") {
		Write-log -message "file $($rootFolder)\source\Eicar\eicar test file.txt already exist, ignoring it" -severity 2
	} else {
		Write-log -message "Creating EICAR AV TEST File" -severity 1
		New-Folder -FolderPath ("$($rootFolder)\source\Eicar")
		"$($eicarString1)$($eicarString2)" | Out-File -FilePath "$($rootFolder)\source\Eicar\eicar test file.txt" -Encoding default
	}
} catch {
	Write-log -message "Error: $_" -severity 3
}

##adkW10 extract files
try {
	if (Test-Path "$($rootFolder)\source\AdkW10") {
		Write-log -message "Folder $($rootFolder)\source\AdkW10 already exist, ignoring it" -severity 2
	} else {
		Write-log -message "Executing adksetup" -severity 1
		New-Folder -FolderPath ("$($rootFolder)\source\adkW10")
		Start-Process -Filepath ("$($rootFolder)\source\AdkW10Download\adksetup.exe") -ArgumentList ("/layout $($rootFolder)\source\AdkW10 /quiet") -Wait -NoNewWindow
	}
} catch {
	Write-log -message "Error: $_" -severity 3
}

##adkW10 winpe extract files
try {
	if (Test-Path "$($rootFolder)\source\AdkW10WinPe") {
		Write-log -message "Folder $($rootFolder)\source\AdkW10WinPe already exist, ignoring it" -severity 2
	} else {
		Write-log -message "Executing adkwinpesetup" -severity 1
		New-Folder -FolderPath ("$($rootFolder)\source\AdkW10WinPe")
		Start-Process -Filepath ("$($rootFolder)\source\AdkW10Download\adkwinpesetup.exe") -ArgumentList ("/layout $($rootFolder)\source\AdkW10WinPe /quiet") -Wait -NoNewWindow
	}
} catch {
	Write-log -message "Error: $_" -severity 3
}

##adkW10 fix extract files
try {
	if (Test-Path "$($rootFolder)\source\AdkW10Fix") {
		Write-log -message "Folder $($rootFolder)\source\AdkW10Fix already exist, ignoring it" -severity 2
	} else {
		Write-log -message "Extracting WSIM1903.zip" -severity 1
		[System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')
		[System.IO.Compression.ZipFile]::ExtractToDirectory("$($rootFolder)\source\AdkW10Download\WSIM1903.zip", "$($rootFolder)\source\AdkW10Fix")
	}
} catch {
	Write-log -message "Error: $_" -severity 3
}

##Extract MECM CB Files
try {
	if (Test-Path "$($rootFolder)\source\MECMCB\Extract") {
		Write-log -message "Folder $($rootFolder)\source\MECMCB\Extract already exist, ignoring it" -severity 2
	} else {
		Write-log -message "Extract MECM CB Files" -severity 1
		Start-Process -Filepath ("$($rootFolder)\source\MECMCB\SC_Configmgr_CB.exe") -ArgumentList ("/auto") -wait -NoNewWindow
		start-sleep 5
		Start-Process -FilePath ("c:\windows\system32\robocopy.exe") -ArgumentList ("C:\SC_Configmgr_SCEP_1902 $($rootFolder)\source\MECMCB\Extract /s /e /copy:DAT /r:1 /w:1 /xj /xjd /xjf") -wait -NoNewWindow
		Remove-Item "C:\SC_Configmgr_SCEP_1902" -force -recurse
	}
} catch {
	Write-log -message "Error: $_" -severity 3
}

##MECM Redist Files
try {
	if (Test-Path "$($rootFolder)\source\MECMCB\Redist") {
		Write-log -message "Folder $($rootFolder)\source\MECMCB\Redist already exist, ignoring it" -severity 2
	} else {
		Write-log -message "MECM Redist Files" -severity 1
		Start-Process -Filepath ("$($rootFolder)\source\MECMCB\Extract\SMSSETUP\BIN\X64\setupdl.exe") -ArgumentList ("$($rootFolder)\source\MECMCB\Redist") -wait -NoNewWindow
	}
} catch {
	Write-log -message "Error: $_" -severity 3
}

##Extract W10 EE
try {
	if (Test-Path "$($rootFolder)\source\W10EE") {
		Write-log -message "Folder $($rootFolder)\source\W10EE already exist, ignoring it" -severity 2
	} else {
		Write-log -message "Extract W10 EE" -severity 1
		$mountResult = Mount-DiskImage -ImagePath ("$($rootFolder)\isos\W10EE.iso")
		start-sleep 5
		$DriveLetter =($mountResult | Get-Volume).DriveLetter
		Start-Process -FilePath ("c:\windows\system32\robocopy.exe") -ArgumentList ("$($DriveLetter):\ $($rootFolder)\source\W10EE /s /e /copy:DAT /r:1 /w:1 /xj /xjd /xjf") -wait -NoNewWindow
		Dismount-DiskImage -ImagePath ("$($rootFolder)\isos\W10EE.iso")
		start-sleep 5
	}
} catch {
	Write-log -message "Error: $_" -severity 3
}

##Extract W8.1 EE
try {
	if (Test-Path "$($rootFolder)\source\W81EE") {
		Write-log -message "Folder $($rootFolder)\source\W81EE already exist, ignoring it" -severity 2
	} else {
		Write-log -message "Extract W8.1 EE" -severity 1
		$mountResult = Mount-DiskImage -ImagePath ("$($rootFolder)\isos\W81EE.iso")
		start-sleep 5
		$DriveLetter =($mountResult | Get-Volume).DriveLetter
		Start-Process -FilePath ("c:\windows\system32\robocopy.exe") -ArgumentList ("$($DriveLetter):\ $($rootFolder)\source\W81EE /s /e /copy:DAT /r:1 /w:1 /xj /xjd /xjf") -wait -NoNewWindow
		Dismount-DiskImage -ImagePath ("$($rootFolder)\isos\W81EE.iso")
		start-sleep 5
	}
} catch {
	Write-log -message "Error: $_" -severity 3
}

##Extract WS2019
try {
	if (Test-Path "$($rootFolder)\source\WS2019") {
		Write-log -message "Folder $($rootFolder)\source\WS2016 already exist, ignoring it" -severity 2
	} else {
		Write-log -message "Extract WS2019" -severity 1
		$mountResult = Mount-DiskImage -ImagePath ("$($rootFolder)\isos\WS2019.iso")
		start-sleep 5
		$DriveLetter =($mountResult | Get-Volume).DriveLetter
		Start-Process -FilePath ("c:\windows\system32\robocopy.exe") -ArgumentList ("$($DriveLetter):\ $($rootFolder)\source\WS2019 /s /e /copy:DAT /r:1 /w:1 /xj /xjd /xjf") -wait -NoNewWindow
		Dismount-DiskImage -ImagePath ("$($rootFolder)\isos\WS2019.iso")
		start-sleep 5
	}
} catch {
	Write-log -message "Error: $_" -severity 3
}

##Extract SQL2017
try {
	if (Test-Path "$($rootFolder)\source\SQLServer\Extract") {
		Write-log -message "Folder $($rootFolder)\source\SQLServer\Extract already exist, ignoring it" -severity 2
	} else {
		Write-log -message "Extract SQL2017" -severity 1
		$mountResult = Mount-DiskImage -ImagePath ("$($rootFolder)\isos\SQLServer2017-x64-ENU.iso")
		start-sleep 5
		$DriveLetter =($mountResult | Get-Volume).DriveLetter
		Start-Process -FilePath ("c:\windows\system32\robocopy.exe") -ArgumentList ("$($DriveLetter):\ $($rootFolder)\source\SQLServer\Extract /s /e /copy:DAT /r:1 /w:1 /xj /xjd /xjf") -wait -NoNewWindow
		Dismount-DiskImage -ImagePath ("$($rootFolder)\isos\SQLServer2017-x64-ENU.iso")
		start-sleep 5
	}
} catch {
	Write-log -message "Error: $_" -severity 3
}

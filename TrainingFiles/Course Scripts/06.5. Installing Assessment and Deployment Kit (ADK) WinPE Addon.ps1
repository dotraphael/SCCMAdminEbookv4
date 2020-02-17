Start-Process -Filepath ("\\srv0001\TrainingFiles\Source\AdkW10WinPe\adkwinpesetup.exe") -ArgumentList ("/Features OptionId.WindowsPreinstallationEnvironment /norestart /quiet /ceip off") -wait -NoNewWindow
start-sleep 5

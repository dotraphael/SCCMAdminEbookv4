Start-Process -Filepath ("\\srv0001\TrainingFiles\Source\AdkW10\adksetup.exe") -ArgumentList ("/Features OptionId.DeploymentTools OptionId.ImagingAndConfigurationDesigner OptionId.UserStateMigrationTool /norestart /quiet /ceip off") -wait -NoNewWindow
start-sleep 5

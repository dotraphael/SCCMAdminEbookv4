$AppName = "Google Chrome"
New-CMApplication -Name "$AppName"

Add-CMMsiDeploymentType -ApplicationName "$AppName" -ContentLocation "\\srv0001\TrainingFiles\Source\Chrome for Windows\googlechromestandaloneenterprise64.msi" -DeploymentTypeName "Google Chrome - Windows Installer (*.msi file)"

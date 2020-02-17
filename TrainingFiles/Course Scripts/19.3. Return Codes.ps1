$AppName = "Google Chrome"
$DTName = "Google Chrome - Windows Installer (*.msi file)"
([xml](Get-CMDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName").SDMPackageXML).AppMgmtDigest.deploymenttype.installer.customdata.exitcodes.exitcode

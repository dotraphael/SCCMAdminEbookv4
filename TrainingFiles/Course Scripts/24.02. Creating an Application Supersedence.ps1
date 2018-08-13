$OldAppName = "Firefox 40"
$OldDTName = "Firefox 40 Installation for Windows 8.1 and 10"

$NewAppName = "Firefox 49"
$NewDTName = "Firefox 49 Installation for Windows 8.1 and 10"

$OldDeploymentType = Get-CMDeploymentType -ApplicationName "$OldAppName" -DeploymentTypeName "$OldDTName"
$NewDeploymentType = Get-CMDeploymentType -ApplicationName "$NewAppName" -DeploymentTypeName "$NewDTName"

Add-CMDeploymentTypeSupersedence -SupersededDeploymentType $OldDeploymentType -SupersedingDeploymentType $NewDeploymentType -IsUninstall $true
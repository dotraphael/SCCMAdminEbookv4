Function Add-CMDeploymentTypeGlobalCondition {
	<#
	.SYNOPSIS
		Add a Requirement to an existing SCCM 2012 Application / Deployment Type
	.DESCRIPTION
		Add a Requirement to an existing SCCM 2012 Application / Deployment Type
	.PARAMETER sdkserver
		Configuration Manager SMS Provider Server. This can be Netbios Name, IP Address or FQDN Name
	.PARAMETER sitecode
		Configuration Manager Site Code
	.PARAMETER GlobalCondition
		Requirement to be added.
		Possible values are:
			OperatingSystem
			TotalPhysicalMemory
			NumberOfProcessors
			OSLanguage
			CPUSpeed
			MachineOU
			PrimaryDevice
			FreeDiskSpace
			Device_OwnershipDesktop
	.PARAMETER Operator
		Operator for the validation. 
		Possible values are:
			IsEquals
			NotEquals
			GreaterThan
			LessThan
			GreaterEquals
			LessEquals
			OneOf
			NoneOf
	.PARAMETER Value
		Value to be added to the requirement

		For values for Operating System, use the SQL Query SELECT ModelName FROM v_CICategories_All where CategoryTypeName = 'Platform'
		For values for Languase, use the SQL Query select distinct cast(Replace(CategoryInstance_UniqueID, 'Locale:', '') as int), CategoryInstanceName  from v_CICategoryInfo where CategoryTypeName='Locale' order by 1
		Values for Device_OwnershipDesktop can only be Company or Personal

	.PARAMETER ApplicationName
		Configuration Manager application name, as apper in the console
	.PARAMETER DeploymentTypeName
		Configuration Manager deployment type, as apper in the console
	.EXAMPLE
		PS C:\PSScript > $ApplicationName = "Google Chrome 39.0.2171.99"
		PS C:\PSScript > $DeploymentTypeName = "MSI - x86"
		PS C:\PSScript > $dkserver = "srv0007"
		PS C:\PSScript > $sitecode = "CLC"
		PS C:\PSScript > $GlobalCondition = "OperatingSystem"
		PS C:\PSScript > $Operator = "NoneOf"
		PS C:\PSScript > $Value = "Windows/x64_Windows_7_Client;Windows/All_x64_Windows_8.1_Client"
		PS C:\PSScript > .\Add-CMDeploymentTypeGlobalCondition.ps1 -ApplicationName "$ApplicationName" -DeploymentTypeName "$DeploymentTypeName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition "$GlobalCondition" -Operator "$Operator" -Value "$Value"

		Will add an Operating System Requirement for an Application where the OS cannot be Windows 7 x64 or Windows 8.1 x64
	.EXAMPLE
		PS C:\PSScript > $ApplicationName = "Google Chrome 39.0.2171.99"
		PS C:\PSScript > $DeploymentTypeName = "MSI - x86"
		PS C:\PSScript > $dkserver = "srv0007"
		PS C:\PSScript > $sitecode = "CLC"
		PS C:\PSScript > $GlobalCondition = "TotalPhysicalMemory"
		PS C:\PSScript > $Operator = "GreaterThan"
		PS C:\PSScript > $Value = (1024 * 1024 * 1024).ToString()
		PS C:\PSScript > .\Add-CMDeploymentTypeGlobalCondition.ps1 -ApplicationName "$ApplicationName" -DeploymentTypeName "$DeploymentTypeName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition "$GlobalCondition" -Operator "$Operator" -Value "$Value"

		Will add a Total Physical Memory Requirement for an Application where the computer has to have more than 1024MB of RAM
	.EXAMPLE
		PS C:\PSScript > $ApplicationName = "Google Chrome 39.0.2171.99"
		PS C:\PSScript > $DeploymentTypeName = "MSI - x86"
		PS C:\PSScript > $dkserver = "srv0007"
		PS C:\PSScript > $sitecode = "CLC"
		PS C:\PSScript > $GlobalCondition = "NumberOfProcessors"
		PS C:\PSScript > $Operator = "IsEquals"
		PS C:\PSScript > $Value = "3"
		PS C:\PSScript > .\Add-CMDeploymentTypeGlobalCondition.ps1 -ApplicationName "$ApplicationName" -DeploymentTypeName "$DeploymentTypeName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition "$GlobalCondition" -Operator "$Operator" -Value "$Value"

		Will add a Number Of Processors Requirement for an Application where the computer has to have 3 processors
	.EXAMPLE
		PS C:\PSScript > $ApplicationName = "Google Chrome 39.0.2171.99"
		PS C:\PSScript > $DeploymentTypeName = "MSI - x86"
		PS C:\PSScript > $dkserver = "srv0007"
		PS C:\PSScript > $sitecode = "CLC"
		PS C:\PSScript > $GlobalCondition = "PrimaryDevice"
		PS C:\PSScript > $Operator = "IsEquals"
		PS C:\PSScript > $Value = "True"
		PS C:\PSScript > .\Add-CMDeploymentTypeGlobalCondition.ps1 -ApplicationName "$ApplicationName" -DeploymentTypeName "$DeploymentTypeName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition "$GlobalCondition" -Operator "$Operator" -Value "$Value"

		Will add a Primary Device Requirement for an Application where the application will only be installed if the user is a primary user of the computer
	.EXAMPLE
		PS C:\PSScript > $ApplicationName = "Google Chrome 39.0.2171.99"
		PS C:\PSScript > $DeploymentTypeName = "MSI - x86"
		PS C:\PSScript > $dkserver = "srv0007"
		PS C:\PSScript > $sitecode = "CLC"
		PS C:\PSScript > $GlobalCondition = "FreeDiskSpace"
		PS C:\PSScript > $Operator = "GreaterThan"
		PS C:\PSScript > $Value = (5 * 1024 * 1024).ToString()
		PS C:\PSScript > .\Add-CMDeploymentTypeGlobalCondition.ps1 -ApplicationName "$ApplicationName" -DeploymentTypeName "$DeploymentTypeName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition "$GlobalCondition" -Operator "$Operator" -Value "$Value"

		Will add a Free Disk Space Requirement for an Application where the computer has to have more than 5GB of disk space on any drive
	.EXAMPLE
		PS C:\PSScript > $ApplicationName = "Google Chrome 39.0.2171.99"
		PS C:\PSScript > $DeploymentTypeName = "MSI - x86"
		PS C:\PSScript > $dkserver = "srv0007"
		PS C:\PSScript > $sitecode = "CLC"
		PS C:\PSScript > $GlobalCondition = "OSLanguage"
		PS C:\PSScript > $Operator = "OneOf"
		PS C:\PSScript > $Value = "9;1046"
		PS C:\PSScript > .\Add-CMDeploymentTypeGlobalCondition.ps1 -ApplicationName "$ApplicationName" -DeploymentTypeName "$DeploymentTypeName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition "$GlobalCondition" -Operator "$Operator" -Value "$Value"

		Will add an OS Language Requirement for an Application where the application will be installed only on English and Brazilian Portuguese languages
	.EXAMPLE
		PS C:\PSScript > $ApplicationName = "Google Chrome 39.0.2171.99"
		PS C:\PSScript > $DeploymentTypeName = "MSI - x86"
		PS C:\PSScript > $dkserver = "srv0007"
		PS C:\PSScript > $sitecode = "CLC"
		PS C:\PSScript > $GlobalCondition = "MachineOU"
		PS C:\PSScript > $Operator = "OneOf"
		PS C:\PSScript > $Value = "CN=Computers,DC=CORP,DC=LOCAL;CN=Computers-Old,DC=CORP,DC=LOCAL"
		PS C:\PSScript > .\Add-CMDeploymentTypeGlobalCondition.ps1 -ApplicationName "$ApplicationName" -DeploymentTypeName "$DeploymentTypeName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition "$GlobalCondition" -Operator "$Operator" -Value "$Value"

		Will add a Machine OU Requirement for an Application where the computer must be part of the Computer or Computers-OS in the active directory
	.EXAMPLE
		PS C:\PSScript > $ApplicationName = "Google Chrome 39.0.2171.99"
		PS C:\PSScript > $DeploymentTypeName = "MSI - x86"
		PS C:\PSScript > $dkserver = "srv0007"
		PS C:\PSScript > $sitecode = "CLC"
		PS C:\PSScript > $GlobalCondition = "CPUSpeed"
		PS C:\PSScript > $Operator = "IsEquals"
		PS C:\PSScript > $Value = "3000"
		PS C:\PSScript > .\Add-CMDeploymentTypeGlobalCondition.ps1 -ApplicationName "$ApplicationName" -DeploymentTypeName "$DeploymentTypeName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition "$GlobalCondition" -Operator "$Operator" -Value "$Value"

		Will add a CPU Speed Requirement for an Application where the computer needs to have CPU equals to 3000MHz
	.EXAMPLE
		PS C:\PSScript > $ApplicationName = "Google Chrome 39.0.2171.99"
		PS C:\PSScript > $DeploymentTypeName = "MSI - x86"
		PS C:\PSScript > $dkserver = "srv0007"
		PS C:\PSScript > $sitecode = "CLC"
		PS C:\PSScript > $GlobalCondition = "Device_OwnershipDesktop"
		PS C:\PSScript > $Operator = "IsEquals"
		PS C:\PSScript > $Value = "Company"
		PS C:\PSScript > .\Add-CMDeploymentTypeGlobalCondition.ps1 -ApplicationName "$ApplicationName" -DeploymentTypeName "$DeploymentTypeName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition "$GlobalCondition" -Operator "$Operator" -Value "$Value"

		Will add a Device Ownership Requirement for an Application where the computer needs to be a company owned computer
	.EXAMPLE
		PS C:\PSScript > $ApplicationName = "Google Chrome 39.0.2171.99"
		PS C:\PSScript > $DeploymentTypeName = "MSI - x86"
		PS C:\PSScript > $dkserver = "srv0007"
		PS C:\PSScript > $sitecode = "CLC"
		PS C:\PSScript > $GlobalCondition = "ADSite"
		PS C:\PSScript > $Operator = "OneOf"
		PS C:\PSScript > $Value = "LONDON"
		PS C:\PSScript > .\Add-CMDeploymentTypeGlobalCondition.ps1 -ApplicationName "$ApplicationName" -DeploymentTypeName "$DeploymentTypeName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition "$GlobalCondition" -Operator "$Operator" -Value "$Value"

		Will add an Active Directory Site Requirement for an Application where the computer needs to be member of an Active Directory Site
	.EXAMPLE
		PS C:\PSScript > $ApplicationName = "Google Chrome 39.0.2171.99"
		PS C:\PSScript > $DeploymentTypeName = "MSI - x86"
		PS C:\PSScript > $dkserver = "srv0007"
		PS C:\PSScript > $sitecode = "CLC"
		PS C:\PSScript > $GlobalCondition = "SCCMSite"
		PS C:\PSScript > $Operator = "OneOf"
		PS C:\PSScript > $Value = "CLC"
		PS C:\PSScript > .\Add-CMDeploymentTypeGlobalCondition.ps1 -ApplicationName "$ApplicationName" -DeploymentTypeName "$DeploymentTypeName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition "$GlobalCondition" -Operator "$Operator" -Value "$Value"

		Will add a SCCM Site Requirement for an Application where the computer/user needs to be member of an SCCM Site
	.INPUTS
		None.  You cannot pipe objects to this script.
	.OUTPUTS
		No objects are output from this script.  
	.LINK
		http://www.rflsystems.co.uk
		http://www.thedesktopteam.com
		http://www.tucandata.com
	.NOTES
		NAME: Add-CMDeploymentTypeGlobalCondition.ps1
		VERSION: 0.02
		AUTHOR: Raphael Perez
		PUBLISHED: November 04, 2016
	#>
	Param (
		[parameter(Mandatory = $True)][string]$sdkserver,
		[parameter(Mandatory = $True)][string]$sitecode,
		[parameter(Mandatory = $True)][ValidateSet("OperatingSystem", "TotalPhysicalMemory", "NumberOfProcessors", "OSLanguage", "CPUSpeed", "MachineOU", "PrimaryDevice", "FreeDiskSpace", "SCCMSite", "ADSite", "Device_OwnershipDesktop", IgnoreCase = $true)] [string]$GlobalCondition,
		[parameter(Mandatory = $True)][ValidateSet("IsEquals", "NotEquals", "GreaterThan", "LessThan", "GreaterEquals", "LessEquals", "OneOf", "NoneOf", IgnoreCase = $true)] [string]$Operator,
		[parameter(Mandatory = $True)][string]$Value,
		[parameter(Mandatory = $True)][string]$ApplicationName,
		[parameter(Mandatory = $True)][string]$DeploymentTypeName
	)
	$ErrorActionPreference = "Stop"
	
	$ConsoleFolder = $Env:SMS_ADMIN_UI_PATH -replace "\\i386", ""
	[System.Reflection.Assembly]::LoadFrom("$($ConsoleFolder)\Microsoft.ConfigurationManagement.ApplicationManagement.dll") | Out-Null
	
	
	##Validation
	switch ($GlobalCondition.Tolower())
	{
		{ ($_ -eq "operatingsystem") -or ($_ -eq "oslanguage") -or ($_ -eq "machineou") -or ($_ -eq "adsite") -or ($_ -eq "sccmsite") } {
			if ($operator -notin @("oneof", "noneof")) { Write-Host "Invalid operation ($Operator) for $GlobalCondition. No further action taken..." -ForegroundColor 'Red'; return }
			
			if ($_ -eq "operatingsystem")
			{
				foreach ($val in $Value.Split(";"))
				{
					if ($val -notin @("Android/All_Android", "Android/All_Android_4_x", "Android/All_Android_5_x", "Android/Android_4_0", "Android/Android_4_1", "Android/Android_4_2", "Android/Android_4_3", "Android/Android_4_4", "Android/Android_5_0", "Android/Android_KNOX_Standard_4", "iOS/All_iOS", "iOS/All_iPad", "iOS/All_iPhone", "iOS/iPad_7", "iOS/iPad_8", "iOS/iPad_9", "iOS/iPhone_7", "iOS/iPhone_8", "iOS/iPhone_9", "Mac/All_Mac", "Mac/All_Mac_10_10", "Mac/All_Mac_10_6", "Mac/All_Mac_10_7", "Mac/All_Mac_10_8", "Mac/All_Mac_10_9", "MacMDM/All_Mac_MDM", "Mobile/All_Mobile", "Symbian/All_Symbian", "Windows/All_ARM_Windows_8.1", "Windows/All_ARM_Windows_8.1_Client", "Windows/All_ARM_Windows_8_Client", "Windows/All_Embedded_Windows_XP", "Windows/All_Holographic_Enterprise_Windows_10_higher", "Windows/All_Holographic_Windows_10_higher", "Windows/All_IA64_Windows_Server_2003_Non_R2", "Windows/All_IA64_Windows_Server_2008", "Windows/All_Team_Windows_10_higher", "Windows/All_Windows_Client_Server", "Windows/All_Windows_RT", "Windows/All_x64_Windows_10_and_higher_Clients", "Windows/All_x64_Windows_10_higher", "Windows/All_x64_Windows_7_Client", "Windows/All_x64_Windows_8.1", "Windows/All_x64_Windows_8.1_and_higher_Clients", "Windows/All_x64_Windows_8.1_Client", "Windows/All_x64_Windows_8_and_higher_Client", "Windows/All_x64_Windows_8_Client", "Windows/All_x64_Windows_Embedded_8.1_Industry", "Windows/All_x64_Windows_Embedded_8_Industry", "Windows/All_x64_Windows_Embedded_8_Standard", "Windows/All_x64_Windows_Server_2003_Non_R2", "Windows/All_x64_Windows_Server_2003_R2", "Windows/All_x64_Windows_Server_2008", "Windows/All_x64_Windows_Server_2008_R2", "Windows/All_x64_Windows_Server_2012_R2", "Windows/All_x64_Windows_Server_2012_R2_and_higher", "Windows/All_x64_Windows_Server_8", "Windows/All_x64_Windows_Server_8_and_higher", "Windows/All_x64_Windows_Vista", "Windows/All_x64_Windows_XP_Professional", "Windows/All_x86_Windows_10_and_higher_Clients", "Windows/All_x86_Windows_10_higher", "Windows/All_x86_Windows_7_Client", "Windows/All_x86_Windows_8.1", "Windows/All_x86_Windows_8.1_and_higher_Clients", "Windows/All_x86_Windows_8.1_Client", "Windows/All_x86_Windows_8_and_higher_Client", "Windows/All_x86_Windows_8_Client", "Windows/All_x86_Windows_Embedded_8.1_Industry", "Windows/All_x86_Windows_Embedded_8_Industry", "Windows/All_x86_Windows_Embedded_8_Standard", "Windows/All_x86_Windows_Server_2003_Non_R2", "Windows/All_x86_Windows_Server_2003_R2", "Windows/All_x86_Windows_Server_2008", "Windows/All_x86_Windows_Vista", "Windows/All_x86_Windows_XP", "Windows/IA64_Windows_Server_2003_SP1", "Windows/IA64_Windows_Server_2003_SP2", "Windows/IA64_Windows_Server_2008_original_release", "Windows/IA64_Windows_Server_2008_SP2", "Windows/x64_Embedded_Windows_7", "Windows/x64_Windows_7_Client", "Windows/x64_Windows_7_SP1", "Windows/x64_Windows_Server_2003_R2_original_release_SP1", "Windows/x64_Windows_Server_2003_R2_SP2", "Windows/x64_Windows_Server_2003_SP1", "Windows/x64_Windows_Server_2003_SP2", "Windows/x64_Windows_Server_2008_Core", "Windows/x64_Windows_Server_2008_original_release", "Windows/x64_Windows_Server_2008_R2", "Windows/x64_Windows_Server_2008_R2_Core", "Windows/x64_Windows_Server_2008_R2_SP1", "Windows/x64_Windows_Server_2008_R2_SP1_Core", "Windows/x64_Windows_Server_2008_SP2", "Windows/x64_Windows_Server_2008_SP2_Core", "Windows/x64_Windows_Vista_Original_Release", "Windows/x64_Windows_Vista_SP1", "Windows/x64_Windows_Vista_SP2", "Windows/x64_Windows_XP_Professional_SP1", "Windows/x64_Windows_XP_Professional_SP2", "Windows/x86_Embedded_Windows_7", "Windows/x86_Windows_7_Client", "Windows/x86_Windows_7_SP1", "Windows/x86_Windows_Server_2003_R2_original_release_SP1", "Windows/x86_Windows_Server_2003_R2_SP2", "Windows/x86_Windows_Server_2003_SP1", "Windows/x86_Windows_Server_2003_SP2", "Windows/x86_Windows_Server_2008_Core", "Windows/x86_Windows_Server_2008_original_release", "Windows/x86_Windows_Server_2008_SP2", "Windows/x86_Windows_Vista_Original_Release", "Windows/x86_Windows_Vista_SP1", "Windows/x86_Windows_Vista_SP2", "Windows/x86_Windows_XP_Professional_Service_Pack_2", "Windows/x86_Windows_XP_Professional_Service_Pack_3", "WindowsMobile/All_Windows_Mobile", "WindowsMobile/Windows_Mobile_6.1", "WindowsMobile/Windows_Mobile_6.5", "WindowsPhone/All_Windows_Phone", "WindowsPhone/Windows_Phone_10_higher", "WindowsPhone/Windows_Phone_8", "WindowsPhone/Windows_Phone_8_1", "WindowsPhone/Windows_Phone_8_1_Embedded"))
					{ Write-Host "Invalid value ($val) for $GlobalCondition. No further action taken..." -ForegroundColor 'Red'; return }
				}
			}
			break
		}
		{ ($_ -eq "totalphysicalmemory") -or ($_ -eq "numberofprocessors") -or ($_ -eq "cpuspeed") -or ($_ -eq "freediskspace") } {
			if ($operator -notin @("isequals", "notequals", "greaterthan", "lessthan", "greaterequals", "lessequals")) { Write-Host "Invalid operation ($Operator) for $GlobalCondition. No further action taken..." -ForegroundColor 'Red'; return }
			break
		}
		"primarydevice" {
			if ($operator -notin @("isequals")) { Write-Host "Invalid operation ($Operator) for $GlobalCondition. No further action taken..." -ForegroundColor 'Red'; return }
			break
		}
		"device_ownershipdesktop" {
			if ($operator -notin @("isequals", "notequals")) { Write-Host "Invalid operation ($Operator) for $GlobalCondition. No further action taken..." -ForegroundColor 'Red'; return }
			if ($Value -notin @("company", "personal")) { Write-Host "Invalid value ($value) for $GlobalCondition. No further action taken..." -ForegroundColor 'Red'; return }
			break
		}
	}
	if ((Get-CMApplication -Name "$ApplicationName") -eq $null) { Write-Host "Application ($ApplicationName) does not exist. No further action taken..." -ForegroundColor 'Red'; return }
	if ((Get-CMDeploymentType -ApplicationName "$ApplicationName" -DeploymentTypeName "$DeploymentTypeName") -eq $null) { Write-Host "DeploymentType ($DeploymentTypeName) for Application ($ApplicationName) does not exist. No further action taken..." -ForegroundColor 'Red'; return }
	##End Validation
	
	switch ($GlobalCondition.Tolower())
	{
		"operatingsystem" {
			$ExpressionBase = new-object "Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.RuleExpression]]"
			$pdDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Other
			break
		}
		"totalphysicalmemory" {
			$GlobalConditionName = "$($GlobalCondition)_Setting_LogicalName"
			$ExpressionBase = new-object "Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]"
			$ConfigurationItemSettingSourceType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingSourceType]::CIM
			$pdSettingDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Int64
			$pdDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Int64
			break
		}
		"numberofprocessors" {
			$GlobalConditionName = "$($GlobalCondition)_Setting_LogicalName"
			$ExpressionBase = new-object "Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]"
			$ConfigurationItemSettingSourceType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingSourceType]::CIM
			$pdSettingDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Int64
			$pdDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Int64
			break
		}
		"oslanguage" {
			$GlobalConditionName = "$($GlobalCondition)_Setting_LogicalName"
			$ExpressionBase = new-object "Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]"
			$ConfigurationItemSettingSourceType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingSourceType]::CIM
			$pdSettingDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Int64
			$pdDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Int64Array
			break
		}
		"cpuspeed" {
			$GlobalConditionName = "$($GlobalCondition)_Setting_LogicalName"
			$ExpressionBase = new-object "Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]"
			$ConfigurationItemSettingSourceType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingSourceType]::CIM
			$pdSettingDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Int64
			$pdDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Int64
			break
		}
		"machineou" {
			$GlobalConditionName = "$($GlobalCondition)_Setting_LogicalName"
			$ExpressionBase = new-object "Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]"
			$ConfigurationItemSettingSourceType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingSourceType]::CIM
			$pdSettingDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::String
			$pdDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::StringArray
			break
		}
		"adsite" {
			$GlobalConditionName = "$($GlobalCondition)_RegSetting_LogicalName"
			$ExpressionBase = new-object "Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]"
			$ConfigurationItemSettingSourceType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingSourceType]::Registry
			$pdSettingDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::String
			$pdDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::StringArray
			break
		}
		"sccmsite" {
			$GlobalConditionName = "$($GlobalCondition)_RegSetting_LogicalName"
			$ExpressionBase = new-object "Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]"
			$ConfigurationItemSettingSourceType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingSourceType]::Registry
			$pdSettingDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::String
			$pdDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::StringArray
			break
		}
		"primarydevice" {
			$GlobalConditionName = "$($GlobalCondition)_Setting_LogicalName"
			$ExpressionBase = new-object "Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]"
			$ConfigurationItemSettingSourceType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingSourceType]::CIM
			$pdSettingDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Boolean
			$pdDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Boolean
			break
		}
		"freediskspace" {
			$GlobalConditionName = "FreeSpace"
			$ExpressionBase = new-object "Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]"
			$ConfigurationItemSettingSourceType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingSourceType]::CIM
			$pdSettingDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Int64
			$pdDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Int64
			break
		}
		"device_ownershipdesktop" {
			$GlobalConditionName = "OwnershipDesktop_Setting_LogicalName"
			$ExpressionBase = new-object "Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]"
			$ConfigurationItemSettingSourceType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingSourceType]::CIM
			$pdSettingDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::String
			$pdDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::String
			break
		}
	}
	
	$ExpressionOperator = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]::$operator
	
	$Annotation = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.Annotation
	$Annotation.DisplayName = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.LocalizableString -ArgumentList @("DisplayName", "$GlobalCondition $operator $Value", $null)
	
	switch ($GlobalCondition.Tolower())
	{
		{ ($_ -eq "operatingsystem") } {
			$Value.Split(";") | foreach { $ExpressionBase.Add($_) }
			$expression = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.OperatingSystemExpression -ArgumentList @($ExpressionOperator, $ExpressionBase)
			break
		}
		{ ($_ -eq "machineou") -or ($_ -eq "oslanguage") -or ($_ -eq "adsite") -or ($_ -eq "sccmsite") } {
			$ExpressionBase.Add((new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.GlobalSettingReference -ArgumentList ("GLOBAL", "$GlobalCondition", $pdSettingDataType, "$GlobalConditionName", $ConfigurationItemSettingSourceType)))
			
			$ConstantValueList = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ConstantValueList -ArgumentList ($pdDataType)
			$Value.Split(";") | foreach { $ConstantValueList.AddConstantValue($_) }
			$ExpressionBase.Add($ConstantValueList)
			$expression = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.Expression -ArgumentList @($ExpressionOperator, $ExpressionBase)
			break
		}
		{ ($_ -eq "cpuspeed") } {
			$ExpressionBase.Add((new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.GlobalSettingReference -ArgumentList ("GLOBAL", $GlobalCondition, $pdSettingDataType, "$GlobalConditionName", $ConfigurationItemSettingSourceType)))
			$value.Split(';') | foreach { $ExpressionBase.Add((New-Object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ConstantValue -ArgumentList @([int64]$_, $pdDataType))) }
			$expression = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.Expression -ArgumentList @($ExpressionOperator, $ExpressionBase)
			break
		}
		default
		{
			$ExpressionBase.Add((new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.GlobalSettingReference -ArgumentList ("GLOBAL", "$GlobalCondition", $pdSettingDataType, "$GlobalConditionName", $ConfigurationItemSettingSourceType)))
			$value.Split(';') | foreach { $ExpressionBase.Add((New-Object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ConstantValue -ArgumentList @($_, $pdDataType))) }
			$expression = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.Expression -ArgumentList @($ExpressionOperator, $ExpressionBase)
			break
		}
	}
	$newRule = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.Rule -ArgumentList @("$($GlobalCondition)Rule_$([Guid]::NewGuid().ToString())", [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.NoncomplianceSeverity]::None, $Annotation, $expression)
	
	$App = Get-CMApplication -Name "$ApplicationName"
	
	$AppXML = [Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer]::DeserializeFromString($app.SDMPackageXML)
	$i = 0
	
	foreach ($dt in $AppXML.deploymenttypes)
	{
		if ($dt.Title.ToLower() -ne $DeploymentTypeName.tolower()) { $i++ }
		else { break }
	}
	
	$AppXML.DeploymentTypes[$i].Requirements.Add($newrule)
	$app.SDMPackageXML = [Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer]::Serialize($AppXML)
	$app.Put() | Out-Null
}
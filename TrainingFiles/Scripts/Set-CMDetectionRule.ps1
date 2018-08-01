Function Set-CMDetectionRule {
	Param (
		[parameter(Mandatory = $True)][string]$ApplicationName,
		[parameter(Mandatory = $True)][string]$DeploymentTypeName,
		[parameter(Mandatory = $false)][Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.NoncomplianceSeverity]$NoncomplianceSeverity = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.NoncomplianceSeverity]::None,
		[parameter(Mandatory = $false)][Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]$MultipleRulesOperator = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]::Or,
		[parameter(Mandatory = $false)][string]$RuleName = "IsInstalledRule",

		#registry parameters
		[switch]$CreateRegistryValidation,
		[ValidateSet("ClassesRoot","CurrentConfig","CurrentUser","LocalMachine","Users")][parameter(Mandatory = $false)][string]$RegistryHiveKey = "LocalMachine",
		[parameter(Mandatory = $false)][string]$RegistryKey,
		[parameter(Mandatory = $false)]$RegistryKeyValue,
		[parameter(Mandatory = $false)][string]$RegistryKeyValidationValue,
		[parameter(Mandatory = $false)][bool]$IsRegistry64Bit = $true,
		[parameter(Mandatory = $false)][Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]$RegistryKeyValidationValueOperator = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]::BeginsWith,
		[parameter(Mandatory = $false)][Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]$RegistryKeyValidationValueType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::String,

		#MSI parameters
		[parameter(Mandatory = $false)][switch]$CreateMSIValidation,
		[parameter(Mandatory = $false)][string]$MSIProductCode,

		#File Validation
		[parameter(Mandatory = $false)][switch]$CreateFileValidation,
		[parameter(Mandatory = $false)][String]$FolderPath,
		[parameter(Mandatory = $false)][String]$FileName,
		[parameter(Mandatory = $false)][string]$FileValidationValue,
		[parameter(Mandatory = $false)][bool]$IsPath64bit = $true,
		[parameter(Mandatory = $false)][Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]$FileValidationValueOperator = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]::GreaterEquals,
		[parameter(Mandatory = $false)][string]$FileValidationProperty = "Version",
		[parameter(Mandatory = $false)][Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]$FileValidationValueType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Version
	)
	$ErrorActionPreference = "Stop"

	if ($CreateRegistryValidation) 
	{ 
		if ([String]::IsNullOrEmpty($RegistryKey))
		{
			Write-Host "RegistryKey parameter cannot be null or empty. No further action taken..." -ForegroundColor 'Red'
			return
		}

		if ([String]::IsNullOrEmpty($RegistryKeyValue))
		{
			Write-Host "RegistryKeyValue parameter cannot be null or empty. No further action taken..." -ForegroundColor 'Red'
			return
		}

		if ([String]::IsNullOrEmpty($RegistryKeyValidationValue))
		{
			Write-Host "RegistryKeyValidationValue parameter cannot be null or empty. No further action taken..." -ForegroundColor 'Red'
			return
		}
	}

	if ($CreateMSIValidation) 
	{ 
		if ([String]::IsNullOrEmpty($MSIProductCode))
		{
			Write-Host "MSIProductCode parameter cannot be null or empty. No further action taken..." -ForegroundColor 'Red'
			return
		}
	}

	if ($CreateFileValidation) 
	{ 
		if ([String]::IsNullOrEmpty($FolderPath))
		{
			Write-Host "FolderPath parameter cannot be null or empty. No further action taken..." -ForegroundColor 'Red'
			return
		}
		if ([String]::IsNullOrEmpty($FileName))
		{
			Write-Host "FileName parameter cannot be null or empty. No further action taken..." -ForegroundColor 'Red'
			return
		}
		if ([String]::IsNullOrEmpty($FileValidationValue))
		{
			Write-Host "FileValidationValue parameter cannot be null or empty. No further action taken..." -ForegroundColor 'Red'
			return
		}
		if ([String]::IsNullOrEmpty($FileValidationProperty))
		{
			Write-Host "FileValidationProperty parameter cannot be null or empty. No further action taken..." -ForegroundColor 'Red'
			return
		}
	}

	$TotalRules = 0
	if ($CreateRegistryValidation) { $TotalRules++ }
	if ($CreateMSIValidation) { $TotalRules++ }
	if ($CreateFileValidation) { $TotalRules++ }
	
	$ConsoleFolder = $Env:SMS_ADMIN_UI_PATH -replace "\\i386", ""
	$DcmObjectModelPath = "$($ConsoleFolder)\DcmObjectModel.dll"
	[System.Reflection.Assembly]::LoadFrom($DcmObjectModelPath)  | Out-Null
	[System.Reflection.Assembly]::LoadFrom("$($ConsoleFolder)\Microsoft.ConfigurationManagement.ApplicationManagement.dll") | Out-Null

	$CMApp = Get-CMApplication -Name "$ApplicationName"
	if ($CMApp -eq $null)
	{
		Write-Host "Application ($ApplicationName) does not exist. No further action taken..." -ForegroundColor 'Red'
		return
	}

	if ((Get-CMDeploymentType -ApplicationName "$ApplicationName" -DeploymentTypeName "$DeploymentTypeName") -eq $null) 
	{ 
		Write-Host "DeploymentType ($DeploymentTypeName) for Application ($ApplicationName) does not exist. No further action taken..." -ForegroundColor 'Red'
		return; 
	}

	$CMAppSDMXML =  [Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer]::DeserializeFromString($CMApp.SDMPackageXML)
	if ([string]::IsNullOrEmpty($CMAppSDMXML))
	{
		Write-Host "Application ($ApplicationName) SDMPackageXML is null or empty. No further action taken..." -ForegroundColor 'Red'
		return; 
	}

	$oEnhancedDetection = New-Object Microsoft.ConfigurationManagement.ApplicationManagement.EnhancedDetectionMethod

	if ($CreateRegistryValidation)
	{
		Write-Host "Starting Creating Registry Validation"

		$ConfigurationItemSettingMethodType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingMethodType]::Value


		#Hack for Registry Settings error:
		#$oRegistrySetting = New-Object Microsoft.ConfigurationManagement.DesiredConfigurationManagement.RegistrySetting($null)
		#New-Object : A constructor was not found. Cannot find an appropriate constructor for type

		$sourceSettingFix = @"
using Microsoft.ConfigurationManagement.DesiredConfigurationManagement;
using System;

namespace RegistrySettingNamespace
{
	public class RegistrySettingFix
	{
		private RegistrySetting _registrysetting;

		public RegistrySettingFix(string str)
		{
			this._registrysetting = new RegistrySetting(null);
		}

		public RegistrySetting GetRegistrySetting()
		{
			return this._registrysetting;
		}
	}
}
"@
               
		Add-Type -ReferencedAssemblies $DcmObjectModelPath -TypeDefinition $sourceSettingFix -Language CSharp | out-null
		$temp = New-Object RegistrySettingNamespace.RegistrySettingFix("")
                 
		$oRegistrySetting = $temp.GetRegistrySetting()
		if ($oRegistrySetting -ne $null) 
		{ 
			write-host "--> RegistrySetting object Created" 
		} else {
			write-host "-->  RegistrySetting object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
			return
		}

		$oRegistrySetting.RootKey = $RegistryHiveKey
		$oregistrysetting.Key = $RegistryKey
		$oRegistrySetting.ValueName = $RegistryKeyValue
		$oRegistrySetting.CreateMissingPath = $false
		$oRegistrySetting.Is64Bit = $IsRegistry64Bit
		$oRegistrySetting.SettingDataType = $RegistryKeyValidationValueType

		$oConstValue = New-Object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ConstantValue($RegistryKeyValidationValue, $RegistryKeyValidationValueType)
		if ($oConstValue -ne $null) 
		{ 
			write-host "--> ConstantValue object Created" 
		} 
		else 
		{
			write-host "-->  ConstantValue object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
			return
		}

		$oSettingRef = New-Object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.SettingReference($CMAppSDMXML.Scope, $CMAppSDMXML.Name, $CMAppSDMXML.Version, $oRegistrySetting.LogicalName, $oRegistrySetting.SettingDataType, $oRegistrySetting.SourceType, $false)
		if ($oSettingRef -ne $null) 
		{ 
			write-host "--> SettingReference object Created" 
		} 
		else 
		{
			write-host "-->  SettingReference object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
			return
		}

		$oSettingRef.MethodType = $ConfigurationItemSettingMethodType

		$oRegistrySettingOperands = new-object Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]
		$oRegistrySettingOperands.Add($oSettingRef)
		$oRegistrySettingOperands.Add($oConstValue)

		$RegistryCheckExpression = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.Expression($RegistryKeyValidationValueOperator, $oRegistrySettingOperands)
		if ($RegistryCheckExpression -ne $null) 
		{ 
			write-host "--> RegistryCheckExpression (Expression) object Created" 
		} 
		else 
		{
			write-host "-->  RegistryCheckExpression (Expression) object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
			return
		}

		$oEnhancedDetection.Settings.Add($oRegistrySetting)

		if ($TotalRules -eq 1)
		{
			$regRule = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.Rule($RuleName, $NoncomplianceSeverity, $null, $RegistryCheckExpression)
			if ($regRule -ne $null) 
			{ 
				write-host "--> regRule (Rule) object Created" 
			} 
			else 
			{
				write-host "-->  regRule (Rule) object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
				return
			}

			$oEnhancedDetection.Rule = $regRule
		}
		Write-Host "Ending Creating Registry Validation"
	}

	if ($CreateMSIValidation)
	{
		Write-Host "Starting Creating MSI Validation"
		$MSIConstantValue = "0"
		$IntDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Int64
		$MSIOperator = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]::NotEquals
		$MSIMethodType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingMethodType]::Count

		$oDetectionType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemPartType]::MSI
		$oMSISetting = New-Object Microsoft.ConfigurationManagement.DesiredConfigurationManagement.MSISettingInstance($MSIProductCode, $null)
		if ($oMSISetting -ne $null) 
		{ 
			write-host "--> MSISettingInstance object Created" 
		} 
		else 
		{
			write-host "-->  MSISettingInstance object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
			return
		}

		$oConstValue = New-Object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ConstantValue($MSIConstantValue, $IntDataType)
		if ($oConstValue -ne $null) 
		{ 
			write-host "--> ConstantValue object Created" 
		} 
		else 
		{
			write-host "-->  ConstantValue object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
			return
		}

		$oSettingRef = New-Object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.SettingReference($CMAppSDMXML.Scope, $CMAppSDMXML.Name, $CMAppSDMXML.Version, $oMSISetting.LogicalName, $IntDataType, $oMSISetting.SourceType, $false)
		if ($oSettingRef -ne $null) 
		{ 
			write-host "--> SettingReference object Created" 
		} 
		else 
		{
			write-host "-->  SettingReference object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
			return
		}
		$oSettingRef.MethodType = $MSIMethodType

		$oMSISettingOperands = new-object Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]
		$oMSISettingOperands.Add($oSettingRef)
		$oMSISettingOperands.Add($oConstValue)

		$MSICheckExpression = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.Expression($MSIOperator, $oMSISettingOperands)
		if ($MSICheckExpression -ne $null) 
		{ 
			write-host "--> MSICheckExpression (Expression) object Created" 
		} 
		else 
		{
			write-host "-->  MSICheckExpression (Expression) object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
			return
		}
		$oEnhancedDetection.Settings.Add($oMSISetting)

		if ($TotalRules -eq 1)
		{
			$msiRule = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.Rule($RuleName, $NoncomplianceSeverity, $null, $MSICheckExpression)
			if ($msiRule -ne $null) 
			{ 
				write-host "--> regRule (Rule) object Created" 
			} 
			else 
			{
				write-host "-->  regRule (Rule) object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
				return
			}

			$oEnhancedDetection.Rule = $msiRule
		}
		Write-Host "Ending Creating MSI Validation"
	}

	if ($CreateFileValidation)
	{
		Write-Host "Starting Creating File Validation"
		$ConfigurationItemSettingMethodType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingMethodType]::Value

		$oDetectionType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemPartType]::File
		$oFileSetting = New-Object Microsoft.ConfigurationManagement.DesiredConfigurationManagement.FileOrFolder($oDetectionType, $null)
		if ($oFileSetting -ne $null) 
		{ 
			write-host "--> FileSettingInstance object Created" 
		} 
		else 
		{
			write-host "-->  FileSettingInstance object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
			return
		}

        $oFileSetting.FileOrFolderName = $FileName
        $oFileSetting.Path =  $FolderPath
        $oFileSetting.Is64Bit = $IsPath64bit
        $oFileSetting.SettingDataType = $FileValidationValueType
        #$oFileSetting.ChangeLogicalName()

		$oConstValue = New-Object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ConstantValue($FileValidationValue, $FileValidationValueType)
		if ($oConstValue -ne $null) 
		{ 
			write-host "--> ConstantValue object Created" 
		} 
		else 
		{
			write-host "-->  ConstantValue object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
			return
		}

		$oSettingRef = New-Object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.SettingReference($CMAppSDMXML.Scope, $CMAppSDMXML.Name, $CMAppSDMXML.Version, $oFileSetting.LogicalName, $oFileSetting.SettingDataType, $oFileSetting.SourceType, $false)
		if ($oSettingRef -ne $null) 
		{ 
			write-host "--> SettingReference object Created" 
		} 
		else 
		{
			write-host "-->  SettingReference object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
			return
		}
		$oSettingRef.MethodType = $ConfigurationItemSettingMethodType
		$oSettingRef.PropertyPath = $FileValidationProperty

		$oFileSettingOperands = new-object Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]
		$oFileSettingOperands.Add($oSettingRef)
		$oFileSettingOperands.Add($oConstValue)

		$FileCheckExpression = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.Expression($FileValidationValueOperator, $oFileSettingOperands)
		if ($FileCheckExpression -ne $null) 
		{ 
			write-host "--> FileCheckExpression (Expression) object Created" 
		} 
		else 
		{
			write-host "-->  FileCheckExpression (Expression) object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
			return
		}

		$oEnhancedDetection.Settings.Add($oFileSetting)

		if ($TotalRules -eq 1)
		{
			$FileRule = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.Rule($RuleName, $NoncomplianceSeverity, $null, $FileCheckExpression)
			if ($FileRule -ne $null) 
			{ 
				write-host "--> FileRule (Rule) object Created" 
			} 
			else 
			{
				write-host "-->  FileRule (Rule) object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
				return
			}

			$oEnhancedDetection.Rule = $FileRule
		}
		Write-Host "Ending Creating File Validation"
	}

	if ($TotalRules -gt 1)
	{
		Write-Host "Starting Creating List of Rules"
		$oRules = new-object Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection``1[[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]]
		if ($CreateMSIValidation) { $oRules.Add($MSICheckExpression) }
		if ($CreateRegistryValidation) { $oRules.Add($RegistryCheckExpression) }
		if ($CreateFileValidation) { $oRules.Add($FileCheckExpression) }

		$oRulesExpression = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.Expression($MultipleRulesOperator, $oRules)
		if ($oRules -ne $null) 
		{ 
			write-host "--> RulesExpression (Expression) object Created" 
		} 
		else 
		{
			write-host "-->  RulesExpression (Expression) object Creation failed. No further action taken..." -ForegroundColor 'Red'
			return
		}

		$ListRules = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.Rule($RuleName, $NoncomplianceSeverity, $null, $oRulesExpression)
		if ($ListRules -ne $null) 
		{ 
			write-host "--> ListRules (Rule) object Created" 
		} 
		else 
		{
			write-host "-->  ListRules (Rule) object Creation failed. No further action taken..." -ForegroundColor 'Red'; 
			return
		}
		$oEnhancedDetection.Rule = $ListRules
		Write-Host "Ending Creating List of Rules"
	}

	$i = 0
	$bUpdated = $false;
	foreach ($DT in $CMAppSDMXML.DeploymentTypes)
	{
		if ($DT.Title.ToLower() -eq $DeploymentTypeName.ToLower())
		{
			write-host "Updating Deployment Type ID $($i) XML" 
			$CMAppSDMXML.DeploymentTypes[$i].Installer.DetectionMethod = [Microsoft.ConfigurationManagement.ApplicationManagement.DetectionMethod]::Enhanced
			$CMAppSDMXML.DeploymentTypes[$i].Installer.EnhancedDetectionMethod = $oEnhancedDetection
			$bUpdated = $true
	        break
		}
		else
		{ 
			$i++
		}
	}

	if ($bUpdated)
	{
		write-host "Updating Application XML" 
		$CMApp.SDMPackageXML = [Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer]::SerializeToString($CMAppSDMXML)

		write-host "Saving Data to Database" 
		$CMApp.put()
	}
	else
	{
			write-host "Deployment Type $($DeploymentTypeName) not found. No further action taken..." -ForegroundColor 'Red'
			return
	}
}
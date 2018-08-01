Function Add-TDCMComplianceRegistrySetting {
<#
	.SYSNOPSIS
		Add a Registry Key information an existing CI

	.DESCRIPTION
		Add a Registry Key information to an existing CI

	.PARAMETER InputObject
		Existing CI

	.PARAMETER SettingName
		Name of the Setting

	.PARAMETER RegRootKey
		Root Registry key

	.PARAMETER RegKey
		Registry key to validate information from

	.PARAMETER RegDataType
		Registry key value data type

	.PARAMETER RegKeyValueName
		Registry key value name

	.PARAMETER RegKey64Bit
		Registry key is 64 or 32 bit (if 32bit on 64 machine it will check under WOW6432Node)

	.PARAMETER NoncomplianceSeverity
		Non-Compliance Severity

	.PARAMETER CreateExistentialValidation
		Create Existential Validation

	.PARAMETER CreateMustExistValidation
		Create Must Exist Validation

	.PARAMETER CreateValueValidation
		Create Value Validation

	.PARAMETER ValidationValueDataType
		Validation Value Type

	.PARAMETER ValidationValue
		Validation Value

	.PARAMETER ValidationOperator
		Validation Operator

	.PARAMETER RemediateNonCompliant
		Remediate Non-Compliant

	.PARAMETER ReportNonCompliant
		Report Non-Compliant

	.NOTES
		Name: Add-TDCMComplianceRegistrySetting
		Author: Raphael Perez
                Twitter: @dotraphael
                E-mail: raphael@perez.net.br
                Website: www.thedesktopteam.com
                Source: SCCM Administration E-book (https://tucandata.com/books/sccmadminbook/)

	.EXAMPLE
		New-CMConfigurationItem -Name "Internet Explorer Default Start Page" -CreationType WindowsOS | Add-TDCMComplianceRegistrySetting -SettingName "IE Start Page" -RegRootKey CurrentUser -RegKey "Software\Microsoft\Internet Explorer\Main" -RegKeyValueName "Start Page" -CreateExistentialValidation -CreateMustExistValidation -CreateValueValidation -ValidationValue "http://www.tucandata.com" -RemediateNonCompliant -ReportNonCompliant
		New-CMConfigurationItem -Name "Test1" -CreationType WindowsOS | Add-TDCMComplianceRegistrySetting -SettingName "IE Start Page" -RegRootKey CurrentUser -RegKey "Software\Microsoft\Internet Explorer\Main" -RegKeyValueName "Start Page" -CreateExistentialValidation
		New-CMConfigurationItem -Name "Test1" -CreationType WindowsOS | Add-TDCMComplianceRegistrySetting -SettingName "IE Start Page" -RegRootKey CurrentUser -RegKey "Software\Microsoft\Internet Explorer\Main" -RegKeyValueName "Start Page" -CreateValueValidation -ValidationValue "http://www.tucandata.com" -RemediateNonCompliant
#>

	Param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)][Microsoft.ConfigurationManagement.ManagementProvider.IResultObject]$InputObject,
		[Parameter(Mandatory = $true)][string]$SettingName,
		[Parameter(Mandatory = $false)][Microsoft.ConfigurationManagement.DesiredConfigurationManagement.RegistryRootKey]$RegRootKey = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.RegistryRootKey]::LocalMachine,
		[Parameter(Mandatory = $true)][string]$RegKey,
		[Parameter(Mandatory = $false)][Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]$RegDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::String,
		[Parameter(Mandatory = $true)][string]$RegKeyValueName,
		[Parameter(Mandatory = $false)][bool]$RegKey64Bit = $true,
		[Parameter(Mandatory = $false)][Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.NoncomplianceSeverity]$NoncomplianceSeverity = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.NoncomplianceSeverity]::Critical,
		[parameter(Mandatory = $false)][switch]$CreateExistentialValidation,
		[parameter(Mandatory = $false)][switch]$CreateMustExistValidation,
		[parameter(Mandatory = $false)][switch]$CreateValueValidation,
		[parameter(Mandatory = $false)][Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]$ValidationValueDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::String,
		[parameter(Mandatory = $false)][string]$ValidationValue = "",
		[parameter(Mandatory = $false)][Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]$ValidationOperator = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]::IsEquals,
		[parameter(Mandatory = $false)][switch]$RemediateNonCompliant,
		[parameter(Mandatory = $false)][switch]$ReportNonCompliant

	)
	$ErrorActionPreference = "Stop"

	#Preparation for new Rules
	$objDCM = ConvertTo-CMConfigurationItem -DigestText $InputObject.SDMPackageXML #Serialize from XML to CI object

	$SourceType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingSourceType]::Registry

	#create new Registry Rule
	$objSetting = New-Object ([Microsoft.ConfigurationManagement.DesiredConfigurationManagement.RegistrySetting]) -ArgumentList $objDCM
	$objSetting.RootKey = $RegRootKey
	$objSetting.SettingDataType = $RegDataType 
	$objSetting.Name = $SettingName
	$objSetting.Key = $RegKey 
	$objSetting.ValueName = $RegKeyValueName 
	$objSetting.Is64Bit = $RegKey64Bit
	$objDCM.Settings.ChildSimpleSettings.Add($objSetting)

	if ($CreateExistentialValidation)
	{
		$ruleId = "Rule_$([Guid]::NewGuid().ToString())"
		$ConstDataType = [Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Int64
		$ConstantValue = "0"
		if ($CreateMustExistValidation)
		{
			$RuleName = "$SettingName must exist"
			$Operator = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]::NotEquals
		}
		else
		{
			$RuleName = "$SettingName must not exist"
			$Operator = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]::IsEquals
		}
		
		$methodType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingMethodType]::Count
		$annotationID = "ID-$([Guid]::NewGuid().ToString())"

		$objSettingReference = New-Object ([Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.SettingReference]) -ArgumentList ($objDCM.AuthoringScopeId, $objDCM.LogicalName, $objDCM.Version, $objSetting.LogicalName, $ConstDataType, $SourceType, $false, $methodType, $null)
		$objConstantValue = New-Object ([Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ConstantValue]) -ArgumentList ($ConstantValue, $ConstDataType)

		$objExpressionBase = New-Object ([Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]])
		$objExpressionBase.Add($objSettingReference)
		$objExpressionBase.Add($objConstantValue)

		$objExpression = New-Object ([Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.Expression]) -ArgumentList ($Operator, $objExpressionBase)
		$objAnnotation = new-object ([Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.Annotation])
		$objAnnotation.DisplayName = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.LocalizableString -ArgumentList @("DisplayName", "$RuleName", "$annotationID")

		$objRule = New-Object ([Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.Rule]) -ArgumentList ($ruleId, $NoncomplianceSeverity, $objAnnotation, $objExpression, $objDCM.AuthoringScopeId, $objDCM.LogicalName, $objDCM.PackageVersion)
		$objDCM.Rules.Add($objRule)
	}

	if ($CreateValueValidation)
	{
		$ruleId = "Rule_$([Guid]::NewGuid().ToString())"
		$RuleName = "$SettingName $($ValidationOperator.ToString()) $ValidationValue"
		$methodType = [Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ConfigurationItemSettingMethodType]::Value
		$annotationID = "ID-$([Guid]::NewGuid().ToString())"

		$objConstantValue = New-Object ([Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ConstantValue]) -ArgumentList ($ValidationValue, $ValidationValueDataType)
		$objSettingReference = New-Object ([Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.SettingReference]) -ArgumentList ($objDCM.AuthoringScopeId, $objDCM.LogicalName, $objDCM.Version, $objSetting.LogicalName, $ValidationValueDataType, $SourceType, $false, $methodType, $null)
		$objSettingReference.IsChangeable = $RemediateNonCompliant

		$objExpressionBase = New-Object ([Microsoft.ConfigurationManagement.DesiredConfigurationManagement.CustomCollection[Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.ExpressionBase]])
		$objExpressionBase.Add($objSettingReference)
		$objExpressionBase.Add($objConstantValue)

		$objExpression = New-Object ([Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.Expression]) -ArgumentList ($ValidationOperator, $objExpressionBase)
		$objAnnotation = new-object ([Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.Annotation])
		$objAnnotation.DisplayName = new-object Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.LocalizableString -ArgumentList @("DisplayName", "$RuleName", "$annotationID")

		$objRule = New-Object ([Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Rules.Rule]) -ArgumentList ($ruleId, $NoncomplianceSeverity, $objAnnotation, $objExpression, $objDCM.AuthoringScopeId, $objDCM.LogicalName, $objDCM.PackageVersion)
		$objRule.MarkRuleNonCompliantWhenSettingIsMissing = $ReportNonCompliant
		$objDCM.Rules.Add($objRule)
	}

	$InputObject.SDMPackageXML = $objDCM.GeneratePackageXml()
	$InputObject.Put()
}
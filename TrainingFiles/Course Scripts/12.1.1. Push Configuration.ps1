$SiteCode = "001"
 
$Secure = 'Pa$$w0rd'| ConvertTo-SecureString -AsPlainText -Force
$account = "CLASSROOM\svc_sccmpush"
New-CMAccount -Name "$account" -Password $Secure -SiteCode "$SiteCode"

Set-CMClientPushInstallation -AddAccount "$account" -EnableAutomaticClientPushInstallation $False -EnableSystemTypeConfigurationManager $False -EnableSystemTypeServer $False -EnableSystemTypeWorkstation $False -InstallationProperty "SMSSITECODE=$($SiteCode) FSP=$($servername)" -InstallClientToDomainController $False -SiteCode "$($SiteCode)"

#Enable Kerberos only
$component = gwmi -Namespace ("root\sms\site_$SiteCode") -query "select * From SMS_SCI_Component where FileType=2 and ItemName = 'SMS_DISCOVERY_DATA_MANAGER|SMS Site Server' and SiteCode='$SiteCode'"
$component.get()
$props = $component.Props

$prop = $props | where {$_.PropertyName -eq 'ENABLEKERBEROSCHECK'}
$prop.Value = 2 #change to 3 if NTLM needs to be enabled
$component.Props = $props

$component.Put() | Out-Null

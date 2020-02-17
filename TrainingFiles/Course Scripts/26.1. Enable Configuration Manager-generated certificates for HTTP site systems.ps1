$SiteCode = "001"

Set-CMSite -ClientComputerCommunicationType HttpsOrHttp -SiteCode $SiteCode

$Component =  gwmi -Namespace "root\SMS\site_$($SiteCode)" -query "select * from SMS_SCI_Component where FileType = 2 and ItemName = 'SMS_SITE_COMPONENT_MANAGER|SMS Site Server' and ItemType='Component' and SiteCode='$($SiteCode)'"
$props = $component.Props
$prop = $props | where {$_.PropertyName -eq 'IISSSLState'}
$prop.Value = 1248
$component.Props = $props
$component.Put() | Out-Null

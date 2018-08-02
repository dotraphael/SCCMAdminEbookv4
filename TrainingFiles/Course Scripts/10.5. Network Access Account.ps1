$SiteCode = "001"
 
$Secure = 'Pa$$w0rd'| ConvertTo-SecureString -AsPlainText -Force
$account = "CLASSROOM\svc_sccmna"
New-CMAccount -Name "$account" -Password $Secure -SiteCode $SiteCode
Set-CMSoftwareDistributionComponent -SiteCode $SiteCode -NetworkAccessAccountNames $account

$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

$CurrentExpirationDate = [DateTime]::FromFileTime(((Get-CMDistributionPoint -SiteSystemServerName "$servername").Props | where {$_.PropertyName -eq "CertificateExpirationDate" }).Value1)

Set-CMDistributionPoint -SiteSystemServerName "$servername" -CertificateExpirationTimeUtc "$($CurrentExpirationDate.AddMinutes(1).ToString())"

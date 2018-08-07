#Disable auto-create sw metering rules
Set-CMSoftwareMeteringSetting -AutoCreateDisabledRule $False

#delete all already create sw metering rules
Get-CMSoftwareMeteringRule | Remove-CMSoftwareMeteringRule -Force
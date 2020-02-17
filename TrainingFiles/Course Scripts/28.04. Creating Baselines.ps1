New-CMBaseline -Name "Workstation Baseline" 

$ci1 = Get-CMConfigurationItem -name "Internet Explorer Default Start Page" -Fast
$ci2 = Get-CMConfigurationItem -name "Validate Mozilla Firefox Version" -Fast
Set-CMBaseline -Name "Workstation Baseline" -AddOSConfigurationItem $ci1.CI_ID -AddRequiredConfigurationItem $ci2.CI_ID

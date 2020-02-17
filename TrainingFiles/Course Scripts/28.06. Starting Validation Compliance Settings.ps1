(Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main').'Start Page'

$SMSCli = [wmiclass] "root\ccm:SMS_Client"
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000021}")
start-sleep 10
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000022}")
Start-Sleep 60

$Baselines = gwmi -Namespace root\ccm\dcm -Class SMS_DesiredConfiguration -Filter "DisplayName = 'Workstation Baseline'"

$Baselines | % { 
    $MC = [WmiClass]"root\ccm\dcm:SMS_DesiredConfiguration"
    $InParams = $mc.psbase.GetMethodParameters("TriggerEvaluation")
    $InParams.IsEnforced = $true
    $InParams.IsMachineTarget = $false
    $InParams.Name = "$($_.Name)"
    $InParams.Version = "$($_.Version)"
    $MC.InvokeMethod("TriggerEvaluation", $InParams, $null)
}

start-sleep 60

(Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main').'Start Page'

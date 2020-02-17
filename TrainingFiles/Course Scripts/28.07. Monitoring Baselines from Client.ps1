$Baselines = gwmi -Namespace root\ccm\dcm -Class SMS_DesiredConfiguration -Filter "DisplayName = 'Workstation Baseline'"
$ComplainceTable = @{
    '0' = 'Non-Compliant'
    '1' = 'Compliant'
    '2' = 'Submitted'
    '3' = 'Detecting'
    '4' = 'Detecting'
    '5' = 'Not Evaluated'
}   

$StatusTable = @{
    '0' = 'Evaluated'
    '2' = 'Evaluating'
    '5' = 'Not Evaluated'
} 

#simple report
$Baselines | Select Version, @{Name='Status' ; Expression = { $StatusTable[$_.Status.ToString()] } }, @{Name='Compliance' ; Expression = { $ComplainceTable[$_.Lastcompliancestatus.ToString()] } }, @{Name='Last Evaluation' ; Expression = {$_.ConvertToDateTime($_.LastEvalTime) } } | format-table -AutoSize

#logs
Start-Process -Filepath ("c:\windows\cmtrace.exe") -ArgumentList ("C:\Windows\ccm\logs\CIAgent.log C:\Windows\ccm\logs\CIDownloader.log C:\Windows\ccm\logs\CITaskMgr.log C:\Windows\ccm\logs\DCMAgent.log C:\Windows\ccm\logs\DCMReporting.log C:\Windows\ccm\logs\DcmWmiProvider.log")

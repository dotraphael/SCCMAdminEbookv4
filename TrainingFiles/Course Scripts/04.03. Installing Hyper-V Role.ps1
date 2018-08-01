##Install the Hyper-V Role
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart

#Machine will reboot, to validate if the hyper-v role was installed, use
Get-WindowsFeature -name Hyper-V


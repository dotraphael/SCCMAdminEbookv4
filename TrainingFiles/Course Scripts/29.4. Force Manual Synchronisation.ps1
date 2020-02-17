Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\DWSS' -Name 'LastSynchronizationTime' -Value ''

Get-Service -Name 'DATA_WAREHOUSE_SERVICE_POINT' | Restart-Service

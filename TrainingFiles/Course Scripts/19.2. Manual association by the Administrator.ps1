Get-CMUserDeviceAffinity -DeviceName "WKS0001"
Add-CMUserAffinityToDevice -DeviceName "WKS0001" -UserName "CLASSROOM\User01"
Get-CMUserDeviceAffinity -DeviceName "WKS0001"
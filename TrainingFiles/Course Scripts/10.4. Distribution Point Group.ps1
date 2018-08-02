$servername = "SRV0002.classroom.intranet"
 
New-CMDistributionPointGroup -Name "Training Lab"
Add-CMDistributionPointToGroup -DistributionPointGroupName "Training Lab" -DistributionPointName "$servername"

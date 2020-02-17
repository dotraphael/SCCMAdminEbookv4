#On SRV0001
Get-ADComputer WKS0002 | Move-ADObject -TargetPath 'OU=Disabled,OU=Workstations,OU=Classroom,DC=classroom,DC=intranet'

#On WKS0002
#get service information
Get-Service -Name BITS

#force group policy update
Start-Process -Filepath ("gpupdate") -ArgumentList ("/force") -wait -NoNewWindow
Start-sleep 10

#force group policy update
Start-Process -Filepath ("gpupdate") -ArgumentList ("/force") -wait -NoNewWindow
Start-sleep 10

#get service information, it will generate error if bits does not exist/access denied
Get-Service -Name BITS

#execute evaluation
Start-Process -Filepath ("c:\windows\ccm\ccmeval.exe") -wait -NoNewWindow
Start-sleep 60
$SiteCode = "001"
Start-Process -Filepath ("c:\Program Files (x86)\ConfigMgr 2012 Toolkit R2\ServerTools\runmetersumm.exe") -ArgumentList ("CM_$SiteCode") -wait -NoNewWindow
$SiteCode = "001"
Start-Process -Filepath ("C:\ConfigMgr\tools\ServerTools\runmetersumm.exe") -ArgumentList ("CM_$SiteCode") -wait -NoNewWindow
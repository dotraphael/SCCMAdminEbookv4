Start-Process -Filepath ("\\srv0001\TrainingFiles\Source\SQLServer\SQLServer2017-KB4229789-x64.exe") -ArgumentList ('/quiet /IAcceptSQLServerLicenseTerms /Action=Patch /AllInstances') -wait

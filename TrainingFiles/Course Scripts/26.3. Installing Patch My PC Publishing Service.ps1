Start-Process -Filepath ('msiexec') -ArgumentList ('/i "\\srv0001\TrainingFiles\Source\PatchMyPc\PatchMyPC-Publishing-Service.msi" /qb') -wait -NoNewWindow

foreach ($item in (Get-Item -Path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\Instance Names\SQL" | select-object -ExpandProperty Property)) {
    $instance = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\Instance Names\SQL\").$item
    $info = Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server\$instance\$item\SuperSocketNetLib\Tcp\IpAll" | select TcpDynamicPorts, TcpPort
    "{0} - {1} - {2}" -f $item, $info.TcpDynamicPorts, $info.TcpPort }

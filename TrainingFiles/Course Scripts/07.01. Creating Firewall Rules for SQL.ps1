New-NetFirewallRule -DisplayName "SQL Server (TCP 1433) Inbound " -Action Allow -Direction Inbound -LocalPort 1433 -Protocol TCP
New-NetFirewallRule -DisplayName "SQL Server (TCP 4022) Inbound " -Action Allow -Direction Inbound -LocalPort 4022 -Protocol TCP

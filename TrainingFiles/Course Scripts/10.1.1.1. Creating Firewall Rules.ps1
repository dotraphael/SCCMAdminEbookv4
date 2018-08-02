New-NetFirewallRule -DisplayName "IIS Distribution Point (TCP 80) Inbound" -Action Allow -Direction Inbound -LocalPort 80 -Protocol TCP
New-NetFirewallRule -DisplayName "IIS Distribution Point (TCP 443) Inbound" -Action Allow -Direction Inbound -LocalPort 443 -Protocol TCP

New-NetFirewallRule -DisplayName "IIS Management Point (TCP 80) Inbound" -Action Allow -Direction Inbound -LocalPort 80 -Protocol TCP
New-NetFirewallRule -DisplayName "IIS Management Point (TCP 443) Inbound" -Action Allow -Direction Inbound -LocalPort 443 -Protocol TCP
New-NetFirewallRule -DisplayName "IIS Client Notification (TCP 10123) Inbound" -Action Allow -Direction Inbound -LocalPort 10123 -Protocol TCP

$SiteCode = "001"

Set-CMSiteMaintenanceTask -SiteCode $SiteCode  -Name "Backup SMS Site Server" -DaysOfWeek Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday -Enabled $true -BeginTime "02:00" -LatestBeginTime "05:00" -devicename \\srv0001\MECMBackup

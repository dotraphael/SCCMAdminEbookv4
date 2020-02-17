$SecurityScope = "Application Administrator for Windows 10 Machines"

get-cmApplication -name "Firefox 49" | Add-CMObjectSecurityScope -Name "$SecurityScope"
get-cmApplication -name "Java8" | Add-CMObjectSecurityScope -Name "$SecurityScope"

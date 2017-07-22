import-module activedirectory 
$domain = "openwindows.local" 
$DaysInactive = 365
$time = (Get-Date).Adddays(-($DaysInactive))
 
Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp |

select-object Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | export-csv OldComputers.csv -notypeinformation
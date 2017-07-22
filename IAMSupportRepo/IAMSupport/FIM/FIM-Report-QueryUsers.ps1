
# ===== Powershell script to export data about all Users in the FIM Portal to an XML Report File =====

# ===== Load FIMAutomation PS module ======

if(@(get-pssnapin | where-object {$_.Name -eq "FIMAutomation"} ).count -eq 0) {add-pssnapin FIMAutomation}



# ===== Query FIM for all Person objects (Do not resolve references) =====

$users = Export-FIMConfig -customConfig "/Person" -Uri "http://localhost:5725" -OnlyBaseResources



# ===== Convert queried data to an XML Report file =====

$users | ConvertFrom-FIMResource -file D:\Reports\FIM-Users.xml
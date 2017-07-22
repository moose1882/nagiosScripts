strComputer = "."
Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colServiceList = objWMIService.ExecQuery ("Select * FROM Win32_Service Where Name = 'IdentityManagerService'")

For Each objservice in colServiceList
errReturn1 = objService.change(,,,,,,"openwindows\idaas.admin","0p3nW1nd0w5")

If errReturn1 <> 0 then
msgbox("2 IDaaS_Srvc_LogOn - When trying to Log onto the Identity Service. " & errReturn1 )
End if

If errReturn1 = 0 then
errReturn2 = objService.startservice
If errReturn2 <> 0 then
msgbox("2 IDaaS_Srvc_LogOn - When trying to Start the Identity Service. " & errReturn2 )
End if
End if

Next

if errReturn1 = 0 and errReturn2 = 0 then
Msgbox("0 IDaaS_Srvc_LogOn - Domain Account is OK. ")
end if


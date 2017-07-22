Dim valWarning
Dim valCritical
Dim valTotal

valWarning = Wscript.Arguments.Item(0)
valCritical = Wscript.Arguments.Item(1)
valWarning = CInt(valWarning)
valCritical = CInt(valCritical)

strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("select * from Win32_PerfRawData_W3SVC_WebService WHERE Name='_Total'")
For Each objItem in colItems
valTotal = objItem.CurrentConnections

Next

valtotal = CInt(valTotal)

if valTotal > 0 then
if valTotal >= valCritical then
wscript.Echo "Critical: number of connections: " & valTotal & "|connections=" & valTotal & ";" & valWarning & ";" & valCritical & ";;"
wscript.Quit(2)
elseif valTotal >= valWarning then
wscript.Echo "Warning: number of connections: " & valTotal & "|connections=" & valTotal & ";" & valWarning & ";" & valCritical & ";;"
wscript.Quit(1)
else
wscript.Echo "OK: number of connections: " & valTotal & "|connections=" & valTotal & ";" & valWarning & ";" & valCritical & ";;"
wscript.Quit(0)
end if
End If
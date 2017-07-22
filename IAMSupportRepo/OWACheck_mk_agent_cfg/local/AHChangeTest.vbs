Set FSO = CreateObject("Scripting.FileSystemObject")
Set objFolder = FSO.GetFolder("C:\Scripts\IAMSupport\")
Set objFiles = objFolder.Files 


    If FSO.FileExists("C:\Scripts\IAMSupport\ErrorLog.txt") Then
        
	Set file = fso.OpenTextFile("C:\Scripts\IAMSupport\ErrorLog.txt", 1)
	content = file.ReadAll
	WScript.Echo "2 AHscript_error - Change Over NOT done. Error says: " & content
	Else
	WScript.Echo "0 AHscript_error - ErrorLog.txt NOT found"
    End If

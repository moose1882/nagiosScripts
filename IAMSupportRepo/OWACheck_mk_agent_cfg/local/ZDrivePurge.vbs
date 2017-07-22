Set FSO = CreateObject("Scripting.FileSystemObject")
Set objFolder = FSO.GetFolder("C:\Scripts\Purge_F_Drive\")
Set objFiles = objFolder.Files 


    If FSO.FileExists("C:\Scripts\Purge_F_Drive\ErrorLog.txt") Then
        
	Set file = fso.OpenTextFile("C:\Scripts\IAMSupport\ErrorLog.txt", 1)
	content = file.ReadAll
	WScript.Echo "2 ZDrive_Purge_Error - Purge NOT Successful. Error says: " & content
	Else
	WScript.Echo "0 ZDrive_Purge - Purge Successful"
    End If

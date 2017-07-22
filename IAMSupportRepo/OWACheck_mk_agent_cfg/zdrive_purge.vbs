Set FSO = CreateObject("Scripting.FileSystemObject")
Set objFolder = FSO.GetFolder("C:\Scripts\Purge_F_Drive\")
Set objFiles = objFolder.Files 

    If FSO.FileExists("C:\Scripts\Purge_F_Drive\ErrorLog.txt") Then
        
	Set file = fso.OpenTextFile("C:\Scripts\Purge_F_Drive\ErrorLog.txt", 1)
	content = file.ReadAll
	WScript.Echo "2 zdrive_purge - Purge NOT Successful. Error says: " & content
	Else
Set objFile = FSO.OpenTextFile("C:\Scripts\Purge_F_Drive\RecentlyDeleted.txt")
Do Until objFile.AtEndOfStream
    strLine= objFile.ReadLine
    'set var to be the line stored in the file
	strLastModified=strLine
	'WScript.echo strLastModified
Loop
objFile.Close

	WScript.Echo "0 zdrive_purge - Purge Successful :" & strLine
    End If

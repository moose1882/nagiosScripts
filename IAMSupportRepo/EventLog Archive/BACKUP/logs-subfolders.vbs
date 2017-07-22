Dim fso, winShell, zipFolder, logFolder, file
Set fso = CreateObject("Scripting.FileSystemObject")
Set winShell = createObject("shell.application")
Set WshNetwork = WScript.CreateObject("WScript.Network")
Set objFSO = CreateObject("Scripting.FileSystemObject")
objStartFolder = "D:\Logs\"
Set objFolder = objFSO.GetFolder(objStartFolder)
Set SubF = objFolder.SubFolders
Set colFiles = objFolder.Files
intAge = 7
for each objFolder in SubF
		zipFileName = "D:\BACKUP\archiveStaging\" & WshNetwork.ComputerName & "-" &  DatePart("YYYY",Date) &  DatePart("m",Date) & DatePart("d",Date)& "-" & objFolder.Name & "LogArchive.zip"
	Set file = fso.CreateTextFile(zipFileName, True)
		file.write("PK" & chr(5) & chr(6) & string(18,chr(0)))
		file.close
	winShell.NameSpace(zipFileName).CopyHere winShell.NameSpace(objFolder.Path & "\")
		wscript.sleep 60000
	MoveAFile (zipFileName)
Next
	
Set objFSO1 = CreateObject("Scripting.FileSystemObject")
Set objFolder1 = objFSO1.GetFolder("D:\Logs\WindowsEventLogs\")
Set colFiles1 = objFolder1.Files
    For Each objFile in colFiles1
		If left(objFile.Name, 7) = "Archive" Then
			objFSO1.DeleteFile "D:\Logs\WindowsEventLogs\" & objFile.Name
		End If
    Next
	
Sub MoveAFile(Drivespec)
   Dim fso
   Set fso = CreateObject("Scripting.FileSystemObject")
   wscript.sleep 60000
   fso.MoveFile Drivespec, "\\prod-ad-01\Software\AWSuploads\eventlogArchives\"
End Sub
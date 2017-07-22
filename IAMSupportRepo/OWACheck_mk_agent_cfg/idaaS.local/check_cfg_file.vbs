strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set objFSO=CreateObject("Scripting.FileSystemObject")
'open the text file and read in the stored Last Modified
strFile = "C:\Program Files (x86)\Quest Software\check_mk\local\cfg_last_check.txt"
Set objFile = objFSO.OpenTextFile(strFile)
Do Until objFile.AtEndOfStream
    strLine= objFile.ReadLine
    'set var to be the line stored in the file
	strLastModified=strLine
	'WScript.echo strLastModified
Loop
objFile.Close

'Look at the file and get it's current LastModified
Set colFiles = objWMIService.ExecQuery _
    ("Select * from CIM_Datafile Where Name = 'C:\\Program Files (x86)\\Quest Software\\Quest One Identity Manager\\JobService.cfg'")
											   
For Each objFile2 in colFiles
'set the var to be the actual Modified time
    crntModified = objFile2.LastModified
	'WScript.echo crntModified & " : " & strLastModified
Next

'Check the two strings. If different shout!
If strLastModified = crntModified Then
WScript.echo "0 IDaaS_cfg_file_chk - " & "JobService.cfg: has NOT changed"
Else
WScript.echo "2 IDaaS_cfg_file_chk - " & "JobService.cfg: HAS changed"
'goto End
End If

'This in not needed as I want to break on file changed.
'now write the current modified time to the file
	'outFile="C:\Program Files (x86)\Quest Software\check_mk\local\cfg_last_check.txt"
	'Set objFile = objFSO.CreateTextFile(outFile,True)
	'objFile.Write crntModified
	'objFile.Close 



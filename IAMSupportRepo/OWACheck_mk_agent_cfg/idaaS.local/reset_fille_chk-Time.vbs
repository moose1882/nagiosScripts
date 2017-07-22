strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set objFSO=CreateObject("Scripting.FileSystemObject")

'Look at the file and get it's current LastModified
Set colFiles = objWMIService.ExecQuery _
    ("Select * from CIM_Datafile Where Name = 'C:\\Program Files (x86)\\Quest Software\\Quest One Identity Manager\\JobService.cfg'")
											   
For Each objFile2 in colFiles
'set the var to be the actual Modified time
    crntModified = objFile2.LastModified
Next

'This in not needed as I want to break on file changed.
'now write the current modified time to the file
	outFile="C:\Program Files (x86)\Quest Software\check_mk\local\cfg_last_check.txt"
	Set objFile = objFSO.CreateTextFile(outFile,True)
	objFile.Write crntModified
	objFile.Close 



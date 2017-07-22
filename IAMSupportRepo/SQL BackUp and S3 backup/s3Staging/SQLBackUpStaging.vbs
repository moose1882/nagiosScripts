' Move SQL backups that are older then 2 weeks to the S3Staging folder on e: Drive
'To be run on Mondays, one day after the Full Backup on Sunday so two weeks ago = 15 days
' D Furlotte 23/02/2016

'DECLARATIONS
Option Explicit
DIM archiveDate, zipResult, uploadResult
DIM objFile, objPath, objFolder, diffPath,fullPath,sysFullPath,transPath,  RetVal, f1, f2
DIM diffStage, fullStage, sysFullStage, transStage, stagingFolder, awsUpload, uploadFolder
DIM objFSO1,objFSO2, objFSO3, objFSO4,  objStartFolder, colFiles, objFileLog
DIM diffCount, fullCount, sysCount, transCount, dtmDate, intAge, objShell, ZipFileCmd, archiveName,extententionType
DIM DiffZipCmd, FullZipCmd, TransZipCmd, sysDBZipCmd
Set objFSO1 = CreateObject("Scripting.FileSystemObject")
Set objFSO2 = CreateObject("Scripting.FileSystemObject")
Set objFSO3 = CreateObject("Scripting.FileSystemObject")
Set objFSO4 = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")

'establish the amount of days that file modified date will search for.
archiveDate = 16

'define file paths
diffPath = "F:\DifferentialBackUps\" 'Path to SQL differential backups
fullPath = "F:\FullBackUps\"
sysFullPath = "F:\FullSystemDBBackUps\"
transPath = "F:\TransBackUp\"
diffStage = "E:\s3Staging\stage\DifferentialBackUps\" 'Path to SQL differential backups staging folder
fullStage = "E:\s3Staging\stage\FullBackUps\"
sysFullStage = "E:\s3Staging\stage\FullSystemDBBackUps\"
transStage = "E:\s3Staging\stage\TransBackUp\"
uploadFolder = "H:\AWSuploads\eventlogArchives\"
'''''''''''''''''
'Housekeeping
'''''''''''''''''
' Set up the monitoring files
' Create a failed.txt file and only rername it to success.txt upoon full script completion
' That way if the script bails at any point, BB will pick up the failed.txt
If objFSO2.FileExists("E:\ArchiveLogs\monitoring\completed.txt") Then
	objFSO2.MoveFile "E:\ArchiveLogs\monitoring\completed.txt", "E:\ArchiveLogs\monitoring\failed.txt"
Else
	objFSO2.CreateTextFile("E:\ArchiveLogs\monitoring\failed.txt")
End If

' Open the session log file for appending
	Set objFileLog = objFSO3.OpenTextFile("E:\ArchiveLogs\AWSBackup_session.log",8) 
'''''''''''''''''
'End Housekeeping
'''''''''''''''''

'Debug
' Used to skip over the time sucking wait for full DB zipping
 Set objFSO3 = CreateObject("Scripting.FileSystemObject")
 If (objFSO3.FileExists("E:\s3Staging\debug.txt")) Then
				logWriter  "Debug file exists! Skipping to sysFullBackUp Sub."   ' send2LOG
	sysFullCopy
	transCopy
	uploadToAws
 Else
				logWriter ("Debug file does not exist! Starting the diffCopy Sub.")   ' send2LOG
	diffCopy
	FullBackUp
	sysFullCopy
	transCopy
	uploadToAws
 End If

'''''''''''''''''
'End of script Housekeeping
'''''''''''''''''


REM **************
REM Monitoring
REM **************
' If the number of volumes found equal the number of snapshots taken and equals the number of snapshots tagged, write a file out so that BB can pick it up. 
If (zipResult + uploadResult) = 0 then
	If objFSO2.FileExists("E:\ArchiveLogs\monitoring\failed.txt") Then
		objFSO2.MoveFile "E:\ArchiveLogs\monitoring\failed.txt", "E:\ArchiveLogs\monitoring\completed.txt"
	Else
		objFSO2.OpenTextFile("E:\ArchiveLogs\monitoring\completed.txt")
	End If
	Set f1 = objFSO2.OpenTextFile("D:\Services\Scripts\AWSbackup\monitor\completed.txt", 2)
		f1.write Now & " Zipped " & (diffCount+fullCount+sysCount+transCount) &" SQL files. Upload to AWS sucessful"
		f1.Close
Else
	Set f2 = objFSO2.OpenTextFile("E:\ArchiveLogs\monitoring\failed.txt", 8)
		If zipResult > 0 then
			f2.write Now & " Zip failed |"
			f2.Close
		ElseIf uploadResult > 0 then
			f2.write " | " & Now & " AWS upload failed. "  & (diffCount+fullCount+sysCount+transCount) & " Zip files created. |"
			f2.Close
		End If
End If

				logWriter  "Session Closed" ' send2LOG
				logWriter  "**************" ' send2LOG
	objFileLog.Close 'close the log file
	wscript.quit
	
REM **************
REM diffCopy
REM Copy the Differential backups'get 15 day old backups from the Diff Folder
REM **************
Sub diffCopy()
				logWriter  "Starting Diff file copy"   ' send2LOG
Set objStartFolder = objFSO1.GetFolder(diffPath)
Set colFiles = objStartFolder.Files
diffCount = 0
intAge = 0
				logWriter  "starting to find the diff files"   ' send2LOG
For Each objFile in colFiles
    dtmDate = objFile.DateLastModified
    intAge = DateDiff("d", dtmDate, Date)
    If intAge >= archiveDate Then
				objFSO1.CopyFile diffPath & objFile.Name, diffStage    ' send2LOG
        diffCount = diffCount + 1
	End If
Next
If diffCount > 0 Then
				logWriter  "Copied " & diffCount & " diff files to : " & diffstage    ' send2LOG
Else
				logWriter  "No diff files have been copied to " & diffstage & " . Exiting this Sub routine"    ' send2LOG
		Exit Sub
End If
				logWriter  "Starting the diff file zip...."   ' send2LOG
ZipFile "_SQL01_diffArchive", "*.bak", diffStage
				logWriter  "Staring to clean up temp diff files"   ' send2LOG
	cleanTempFile diffStage, "*.bak"
	FullBackUp
End Sub	
	
REM **************
REM FullBackUp
REM Copy the Full Backups'get 15 day old backups from the FullBackUp Folder 
REM **************
Sub FullBackUp()
				logWriter  "Starting fullBackup file copy"   ' send2LOG
Set objStartFolder = objFSO2.GetFolder(fullPath)
Set colFiles = objStartFolder.Files
fullCount = 0
intAge = 0
				logWriter  "starting to fullBackup find the files"   ' send2LOG
For Each objFile in colFiles
    dtmDate = objFile.DateLastModified
    intAge = DateDiff("d", dtmDate, Date)
	If intAge >= archiveDate Then
		objFSO2.CopyFile fullPath & objFile.Name, fullStage 
		fullCount = fullCount + 1
	End If
Next
If fullCount > 0 Then
				logWriter  "Copied " & fullCount & " fullBackup files to : " & fullStage    ' send2LOG
Else
				logWriter  "No fullBackup files have been copied to " & fullStage & " . Exiting this Sub routine"    ' send2LOG
		Exit Sub
End If
				logWriter  "Starting the fullBackup zip...."   ' send2LOG
ZipFile	"_SQL01_FullBackupArchive", "*.bak", fullStage
				logWriter  "FullBackUp is done!"   ' send2LOG
				logWriter  "Staring to clean up temp fullBackup files"   ' send2LOG
	cleanTempFile fullStage, "*.bak"
End Sub	
	
	
REM **************
REM sysFullCopy
REM Copy the sys DBs'get 15 day old backups from the sysFullPath Folder 
REM **************
Sub sysFullCopy()
				logWriter  "Starting sysFullCopy file copy"   ' send2LOG
Set objStartFolder = objFSO3.GetFolder(sysFullPath)
Set colFiles = objStartFolder.Files
sysCount = 0
intAge = 0
				logWriter  "starting to find the sysFullCopy files"   ' send2LOG
For Each objFile in colFiles
    dtmDate = objFile.DateLastModified
    intAge = DateDiff("d", dtmDate, Date)
	If intAge >= archiveDate Then
		objFSO3.CopyFile sysFullPath & objFile.Name, sysFullStage 
        sysCount = sysCount + 1
	End If
Next
If sysCount > 0 Then
				logWriter  "Copied " & sysCount & " sysFullCopy files to : " & sysFullStage    ' send2LOG
Else
				logWriter  "No sysFullCopy files have been copied to " & sysFullStage & " . Exiting this Sub routine"    ' send2LOG
		Exit Sub
End If
				logWriter  "Starting the sysFullCopy zip...."   ' send2LOG
ZipFile "_SQL01_SystemDBArchive", "*.bak", sysFullStage
				logWriter  "sysFullCopy is done!"   ' send2LOG
				logWriter  "Staring to clean up temp sysFullCopy files"   ' send2LOG
	cleanTempFile sysFullStage, "*.bak"
End Sub


REM **************
REM transCopy()
REM get 15 day + old backups from the transPath Folder 
REM **************
Sub transCopy()
				logWriter  "Starting transCopy file copy"   ' send2LOG
Set objStartFolder = objFSO4.GetFolder(transPath)
Set colFiles = objStartFolder.Files
transCount = 0
intAge = 0

For Each objFile in colFiles
    dtmDate = objFile.DateLastModified
    intAge = DateDiff("d", dtmDate, Date)
	If intAge >= archiveDate Then
		objFSO4.CopyFile transPath & objFile.Name, transStage 
        transCount = transCount + 1
	End If
Next
If transCount > 0 Then
				logWriter  "Copied " & transCount & " transCopy files to : " & transStage    ' send2LOG
Else
				logWriter  "No transCopy files have been copied to " & transStage & " . Exiting this Sub routine"    ' send2LOG
		Exit Sub
End If
				logWriter  "Starting the transCopy zip...."   ' send2LOG
ZipFile "_SQL01_transArchive", "*.trn", transStage
				logWriter  "transStage is done!"   ' send2LOG
				logWriter  "Staring to clean up temp transCopy files"   ' send2LOG

		cleanTempFile transStage, "*.trn"
End Sub			

REM **************
REM Upload the zip files to AWS Bucket
REM **************			
Sub uploadToAws()	
				logWriter  "starting the S3 upload."   ' send2LOG
	awsUpload = "aws s3 mv " & uploadFolder & "s3://prod-sql-01-archive/ --recursive"
	uploadResult = objShell.Run(awsUpload,0,true)
	If uploadResult = 0 then
				logWriter  "Bucket upload of *.7z Sucessful. Exit Code = " &uploadResult  ' send2LOG
	Else 
				logWriter  "Bucket upload of *.7z Failed. Exit Code = "  &uploadResult  ' send2LOG
	End If
End Sub

REM **************
REM Zipping up the staged files 
REM **************
Sub zipFile(archiveName,extententionType, stagingFolder)
    ZipFileCmd = "7z a -t7z " & uploadFolder &  DatePart("YYYY",Date) &  DatePart("m",Date) & DatePart("d",Date)& archiveName & ".7z " & stagingFolder & extententionType & " -mx9"
				logWriter  "Starting to zip the files. "   ' send2LOG
	zipResult = objShell.Run(ZipFileCmd,0,true)
	If zipResult = 0 then
				logWriter  "Zipping of " & archiveName & ".7z sucessful" &zipResult  ' send2LOG
	Else 
				logWriter  "Zipping of " & archiveName & ".7z Failed. Exit code = " &zipResult  ' send2LOG
	End If
End Sub

REM **************
REM Cleaning up the staged files 
REM **************
Sub cleanTempFile(directory, extention)
				logWriter "cleaning up " & directory &" files "' send2LOG
	'objFSO1.DeleteFile (directory & extention)
				logWriter "cleaning up done."   ' send2LOG
End Sub

REM **************
REM Write to log
REM **************
Sub logWriter(msg)
				objFileLog.Write  Date & vbTab & Time & vbTab & msg &  VbCrLf  ' send2LOG
End Sub
'vb script to automate the creation of volume snapshots on the D1aaS Production Platform
'uses AWS CLI commands

'DECLARATIONS
Option Explicit
DIM ec2VolumeID(28), ec2SnapID(28),ec2VolumeName(28)
DIM x, y, i, m
DIM strLine, strLine2, strLine3, strLine4
DIM objFSO
DIM objFile,objFileLog
DIM strLastModified
Dim awsShell
DIM awsGetVols, awsCreateSnap, awsTagSnap 'AWS CLI commands
DIM Purgein7Days
Set awsShell = WScript.CreateObject ("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
' END DECLARATIONS

'''''''''''''''''
'Housekeeping
'''''''''''''''''
' Clear snapshotID result file
Set objFile = objFSO.OpenTextFile(".\ec2CreateSnapResult.txt",2)
	objFile.Write ""
	objFile.Close
' Zero out counters
'Open up the session log file. Rotate current log if found.
'used by BB for monitoring the success and/or failure of the script. 
If (objFSO.FileExists("D:\Services\Scripts\AWSbackup\Logs\session.log")) Then ' if there is already a current log file
	'objFSO.GetFile("D:\Services\Scripts\AWSbackup\Logs\session.log").Name = ("session.log_" & Date) 'rename it and add the date tot he file name.
	objFSO.DeleteFile "D:\Services\Scripts\AWSbackup\Logs\session.log_"
	objFSO.MoveFile "D:\Services\Scripts\AWSbackup\Logs\session.log", "D:\Services\Scripts\AWSbackup\Logs\session.log_"
	objFSO.CreateTextFile("D:\Services\Scripts\AWSbackup\Logs\session.log")
	End If
Set objFileLog = objFSO.OpenTextFile("D:\Services\Scripts\AWSbackup\Logs\session.log",2)
x = 0
m = 0
y = 0 
'''''''''''''''''
'End Housekeeping
'''''''''''''''''


'Now tag the new snapshots
'Start tagging the new snapshots
' we are tagging the snapshots with today's date + 7 calendar days
'This will allow us to query on today MINUS 7 days to preform a purge
Purgein7Days = DateAdd("d", 7, date) 'what is the date in 7 days
 Set objFile = objFSO.OpenTextFile(".\ec2CreateSnapResult.txt") ' read in snapshotIDs that were created in the above step.
 Do Until objFile.AtEndOfStream
	strLine4 = objFile.ReadLine
		 ec2SnapID(m) = (strLine4) ' populate SnaphotID into the array
		 m=m+1
 Loop
 objFile.Close
 
 If ec2SnapID(m) = "" then m=m-1
 For i = m to 0 step -1
	 awsTagSnap = "aws ec2 create-tags --resource " & ec2SnapID(i) & " --tags Key=PurgeDate,Value=" & Purgein7Days
	 awsShell.run "cmd.exe /C " & awsTagSnap
 Next
objFileLog.Write (Date) & " - We tagged: " & m & " Production Volumes" & vbCr ' send2LOG


'End of script Housekeeping
objFileLog.write "Session Closed"' send2LOG
objFileLog.write "**************" ' send2LOG
objFileLog.Close
'vb script to automate the creation of volume snapshots on the D1aaS Production Platform
'uses AWS CLI commands

'DECLARATIONS
Option Explicit
DIM ec2SnapID, strLine, x
DIM objFSO, objFile, awsShell, objFileLog
DIM awsGetPurgeSnapID, awsPurgeSnaps
Set awsShell = WScript.CreateObject ("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
' END DECLARATIONS

'''''''''''''''''
'Housekeeping
'''''''''''''''''
' Clear snapshotIDs to purge result file
	Set objFile = objFSO.OpenTextFile(".\ec2_SnapPurgeList.txt", 2)
		objFile.Write ""
	objFile.Close
	
' Delete the monitoring files
If objFSO.FileExists("D:\Services\Scripts\AWSbackup\monitor\completed.txt") Then
	objFSO.DeleteFile("D:\Services\Scripts\AWSbackup\monitor\completed.txt") 
Else
If objFSO.FileExists("D:\Services\Scripts\AWSbackup\monitor\failed.txt") Then
	objFSO.DeleteFile("D:\Services\Scripts\AWSbackup\monitor\failed.txt") 
	end If
End If

' Open the session log file for appending
	Set objFileLog = objFSO.OpenTextFile("D:\Services\Scripts\AWSbackup\Logs\session.log",8) 
	'''''''''''''''''
'End Housekeeping
'''''''''''''''''

			objFileLog.Write (Date) & " - Starting the daily purge of old snapshots " & VbCrLf  ' send2LOG
'Get the snapshots owned by us that have a tag called PurgeDate and a value equal to today's date -7 calendar days
			objFileLog.Write (Date) & " - Getting the snapshots owned by us " & VbCrLf  ' send2LOG
awsGetPurgeSnapID = "aws ec2 describe-snapshots --owner 022543930592 --filters  " & chr(34) & "Name=tag:PurgeDate,Values=" & Date & chr(34) &   "  --query Snapshots[*].SnapshotId  > ec2_SnapPurgeList.txt" 
	awsShell.run "cmd.exe /C" & awsGetPurgeSnapID
WScript.Sleep 2000 ' wait 2 secs until write to file is completed otherwise the following read from file will fail.
			objFileLog.Write (Date) & " - Got the list. " & VbCrLf  ' send2LOG

			
			'The output above is a tab delimited file, single line so read that line in, split it by TAB and assign to an array
Set objFile = objFSO.OpenTextFile(".\ec2_SnapPurgeList.txt")
	if objFSO.GetFile(".\ec2_SnapPurgeList.txt").size = 0 then   'Check if there is anything contained in the above output file, if not terminate the script.
			objFileLog.Write (Date) & " - No snapshots found with a date of " & Date & ". Terminating the script as there is nothing to process." & VbCrLf  ' send2LOG		
			wscript.Quit
	End If
				objFileLog.Write (Date) & " - We have found some snapshots to delete." & VbCrLf  ' send2LOG
		strLine = objFile.ReadLine ' Read the data
		ec2SnapID = Split(strLine, vbTab) 'Split the data by TAB and assign to an array
objFile.Close


			objFileLog.Write (Date) & " - snapshots to be deleted have been added to the array " & VbCrLf  ' send2LOG
for x = 0 to uBound(ec2SnapID) ' Set loop to the upper limit of the above defined array
			objFileLog.Write (Date) & " - Starting the delete process now.." & VbCrLf  ' send2LOG
	awsPurgeSnaps = "aws ec2 delete-snapshot --snapshot-id " & ec2SnapID(x) ' Loop through each snapshotID identified above and added to the array and delete them
	awsShell.run "cmd.exe /C" & awsPurgeSnaps
Next
			objFileLog.Write (Date) & " - Finished deleting old snapshots. " & x & " snapshots were deleted. " & VbCrLf  ' send2LOG

			
objFileLog.write Date & " - Purge Session Closed" & VbCrLf ' send2LOG
objFileLog.write "************************" & VbCrLf ' send2LOG
objFileLog.Close 'close the log file
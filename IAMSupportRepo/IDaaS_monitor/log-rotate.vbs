Option Explicit

Dim StdIn:  Set StdIn = WScript.StdIn
Dim StdOut: Set StdOut = WScript
Dim fso:    Set fso = CreateObject("Scripting.FileSystemObject")

Dim FilesRenamed:   FilesRenamed = 0
Dim FilesSkipped:   FilesSkipped = 0

Main

set fso = nothing

Sub Main
      
   'get the parameter list   
   dim objArgs: Set objArgs = WScript.Arguments

   if objArgs.Count > 2 then
      
    dim path: path = objArgs(0)  'path
    dim olds: olds = objArgs(1)  'string to replace
    dim news: news = objArgs(2)  'new string
    dim ext1: ext1 = ""
    dim ext2: ext2 = ""
    if objArgs.Count > 3 then ext1 = objArgs(3)  'old extension
    if objArgs.Count > 4 then ext2 = objArgs(4)  'new extension            

    dim CurrentFolder: Set CurrentFolder = fso.GetFolder(path)
    StdOut.Echo "Warning: All files within the directory """ & _
                CurrentFolder.Path & """ will be renamed."
    If Not Confirm("Continue?") Then Exit Sub
    
		ProcessSubFolders CurrentFolder , olds, news, ext1,ext2
        StdOut.Echo "Files renamed :" & FilesRenamed
		StdOut.Echo "Files Skipped :" & FilesSkipped 
    else
       StdOut.Echo "Usage: rename.vbs [folder path] [string to replace]" & _ 
                   " [new string] [old extension] [new extension] "
   end if
End Sub
Function Confirm (ByVal promptText)   
      StdOut.Echo promptText & " (y/n) "
      Dim s: s =  StdIn.ReadLine()      
      Select Case LCase(Trim(s))         
         Case "y"         
            Confirm = True
            exit function 
         Case else            
             Confirm = False
             exit function            
      End Select      
         
End Function

Sub ProcessSubFolders (ByVal crfolder, ByVal oldTag, ByVal newTag, ByVal extOld, ByVal extNew)
Dim Folders: Set Folders = crfolder.SubFolders 'process the current folder
Dim Folder 
ProcessFolder crfolder , oldTag, newTag, extOld,extNew
	For Each Folder in Folders 
		ProcessSubFolders Folder , oldTag, newTag, extOld,extNew
	next
End Sub 

Sub ProcessFolder (ByVal folder, ByVal oldTag, ByVal newTag, ByVal extOld, ByVal extNew)
   Dim Files: Set Files = folder.Files
   
   Dim File
   For Each File In Files
   
      If inStr(1,File.Name,oldTag) > 0 Then
      
         if (extOld <> "" and extNew <> "") then
            StdOut.Echo Replace(Replace(File.Path,oldTag,newTag),extOld,extNew)
            File.Move Replace(Replace(File.Path,oldTag,newTag),extOld,extNew)
         else
            StdOut.Echo Replace(File.Path,oldTag,newTag)
            File.Move Replace(File.Path,oldTag,newTag)
         end if
                  
         FilesRenamed = FilesRenamed + 1
      Else
         FilesSkipped = FilesSkipped + 1
       End If
   Next
End Sub
  
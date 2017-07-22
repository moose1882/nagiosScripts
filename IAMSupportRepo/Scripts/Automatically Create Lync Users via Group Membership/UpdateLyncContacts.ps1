###  UpdateLyncContacts.ps1
###  Written by Roland Paix
###  December 2012
###  Version 1.0
###  Lync 2010

#  USAGE

# This script can be used to update all enabled Lync 2010 users' address books with either all Lync contacts in the enterprise or a specific list of contacts.
# Existing contacts in address books won't be affected.
# Specific users can be excluded from receiving missing contacts.
# Specific users can be excluded from being added to address books.
# Works with Standard or Enterprise pools.
# Designed to be run as a scheduled task or on-demand.
# Keeps a backup of all users' homed resouce data.

# Save the script to the location you set in the $ScriptsFolder variable. This needs to be on a front-end server.
# Accounts used to run the script require write access to this folder and must be members of the RTCUniversalServerAdmins group.
# Configure the variables per your organisation's requirements.
# Leave all unused configurable variables disabled (hashed out).
# Leave out the "sip:" prefix from any SIP addresses.


#  CONFIGURABLE VARIABLES

# Testing Mode - When set to $True performs all functions except for importing updated contacts (so no changes to Lync).
#$TestingMode = $True

# Scripts Folder - Set this to the location where you want the script to run from.  Three subfolders (backup, logs & working) will be automatically created in this folder so ensure that this doesn't interfere with existing functions.
$ScriptsFolder = "C:\Scripts"

# Don't Process Users - Enable and populate this variable with SIP addresses of Lync users that you wish to exclude from receiving missing contacts.
#$DontProcessUsers = "jporkins@contoso.com","ydalgargan@contoso.com"

# Don't Add Users - Enable and populate this variable with SIP addresses of Lync users that you wish to exclude from being added to everyone's contacts.
#$DontAddUsers = "wantilles@contoso.com","drendar@contoso.com"

# Common Contacts - Enable and populate this variable with a set of Lync contacts to distribute to all users instead of distributing all users to all users. Overrides $DontAddUsers.
#$CommonContacts = "jdroga@contoso.com","lcalrissian@contoso.com"

# Enterprise Pool SQL Server - If you use an enterprise pool enable and populate this variable with the enterprise pool's SQL server hostname.
#$EPSQLServer = "lyncsql01@contoso.com"

# Email variables - Enable the $EmailEnabled variable to enable email notifications. Populate the $EmailFrom, $EmailTo and $EmailServer variables with sender, recipient(s) and SMTP server details.
#$EmailEnabled = $True
#$EmailFrom = "UpdateLyncContacts_Script@contoso.com"
#$EmailTo = "LyncAdmis@contoso.com"
#$EmailServer = "mailhost.contoso.com"


#  PRE-PROCESSING

$BackupFolder = "$ScriptsFolder\UpdateLyncContacts\Backup"
$LogFolder = "$ScriptsFolder\UpdateLyncContacts\Logs"
$WorkingFolder = "$ScriptsFolder\UpdateLyncContacts\Working"
$DateTime = (Get-Date -Format s) -Replace "T", " " -Replace ":", "."
$DBImpExp = "$Env:CommonProgramFiles\Microsoft Lync Server 2010\Support\DBImpExp.exe"

If(!(Test-Path "$ScriptsFolder\UpdateLyncContacts")){New-Item -ItemType Directory -Path "$ScriptsFolder\UpdateLyncContacts"}
If(!(Test-Path $BackupFolder)){New-Item -ItemType Directory -Path $BackupFolder}
If(!(Test-Path $LogFolder)){New-Item -ItemType Directory -Path $LogFolder}
If(!(Test-Path $WorkingFolder)){New-Item -ItemType Directory -Path $WorkingFolder}

Start-Transcript "$LogFolder\UpdateLyncContacts $DateTime.log" -Append
Write-Host "`r`n'UpdateLyncContacts.ps1'"

Trap{
    Write-Host "`r`n`r`n----------------------------------------------------------------`r`n"
    Write-Host "Error occured!!!!!!!!!:`r`n"
    $_
    Write-Host "`r`n----------------------------------------------------------------`r`n`r`n"
    Stop-Transcript
    If($EmailEnabled){
        $EmailSubject = "The UpdateLyncContacts script has problems"
        $EmailBody = "The UpdateLyncContacts script was not able to complete with the following error:`r`n`r`n $_ `r`nSee the attached log for full details."
        Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -Body $EmailBody -SmtpServer $EmailServer -Attachments "$LogFolder\UpdateLyncContacts $DateTime.log"
    }
    Break
}

If(!(Test-Path $DBImpExp -PathType Leaf)){
    Write-Host "`r`nUnable to find DBImpExp.exe.
Please check that it exists in the default location (the system's 64-bit Program Files\Common Files\Microsoft Lync Server 2010\Support directory)."
    DBImpExp.exeNotFound
}

If($(Get-Module).name -notcontains 'Lync'){
    Import-Module Lync -ErrorAction:Stop
}

If(Get-ChildItem $WorkingFolder){
    Remove-Item "$WorkingFolder\*" -ErrorAction:Stop
}
If(Get-ChildItem $LogFolder){
    Get-ChildItem $LogFolder | ?{$_.LastWriteTime -lt (Get-Date).AddDays(-30) -and -not $_.PSIsContainer} | %{Remove-Item $_.FullName -Force}
}


#  FUNCTIONS

Function Dump-Contacts {
    If(Test-Path Variable:Script:EPSQLServer){
        $Params = "/hrxmlfile:$BackupFolder\$_.xml /sqlserver:$EPSQLServer /user:$_"
    }
    Else{
        $Params = "/hrxmlfile:$BackupFolder\$_.xml /user:$_"
    }

    Write-Host "`r`nDumping contacts for $_..."

    Start-Process "$DBImpExp" -ArgumentList $Params -NoNewWindow -Wait:$True -RedirectStandardOutput "$WorkingFolder\TempOutput.txt"

    Get-Content "$WorkingFolder\TempOutput.txt"
}

Function Process-Contacts {
    Write-Host "`r`n---------------------------------------------`r`nProcessing user: $_`r`n---------------------------------------------"

    $User = $_
    $AllContacts = @($SipAddressesToAdd | ?{$_ -ne $User})
    $UserFile = Get-ChildItem "$BackupFolder\$User.xml"
    $XMLFile = [xml](Get-Content $UserFile.FullName)
    $ExistingContacts = @($XMLFile.HomedResources.HomedResource.Contacts.Contact | Select Buddy -ExpandProperty Buddy)

    Write-Host "`r`nExisting contacts:`r`n"
    $ExistingContacts

    $ContactsToAdd = @($AllContacts | ?{$ExistingContacts -notcontains $_})

    If(!$ContactsToAdd){
        Write-Host "`r`nThere are no contacts to add; skipping to next user."
        Return
    }

    Write-Host "`r`nContacts to add:`r`n"
    $ContactsToAdd
    Write-Host "`r`nAdding Contacts..."

    $ns = New-Object Xml.XmlNamespaceManager $xmlfile.NameTable
    $ns.AddNamespace( "e", "http://schemas.microsoft.com/RtcServer/2002/11/dbimpexp" )

    $XMLFile.SelectNodes("/e:HomedResources/e:HomedResource/*",$ns) | %{$_.ParentNode.RemoveChild($_)}
    $Node = $XMLFile.CreateNode('element','Contacts','http://schemas.microsoft.com/RtcServer/2002/11/dbimpexp')
    $ContactsToAdd | %{
        $NewContact = $XMLFile.CreateElement('Contact','http://schemas.microsoft.com/RtcServer/2002/11/dbimpexp')
        $NewContact.SetAttribute('Buddy',$_)
        $NewContact.SetAttribute('SubscribePresence',1)
        $NewContact.SetAttribute('Groups',1)
        $Node.AppendChild($NewContact)
    }
    $XMLFile.HomedResources.HomedResource.AppendChild($Node)

    Write-Host "Saving import file."

    $XMLFile.Save("$WorkingFolder\$User.xml")
}

Function Update-CSUsers {
    $User = $_.BaseName.ToString()

    If(Test-Path Variable:Script:EPSQLServer){
        $Params = "/Import /hrxmlfile:$($_.FullName) /sqlserver:$EPSQLServer /restype:user /user:$User"
    }
    Else{
        $Params = "/Import /hrxmlfile:$($_.FullName) /restype:user /user:$User"
    }

    Write-Host "`r`nUpdating user $User with the following command:`r`n`r`n" $DBImpExp $Params

    If(!(Test-Path Variable:Script:TestingMode)){
        Start-Process "$DBImpExp" -ArgumentList $Params -NoNewWindow -Wait:$True -RedirectStandardOutput "$WorkingFolder\TempOutput.txt"
        Get-Content "$WorkingFolder\TempOutput.txt"
    }
    Else{
        Write-Host "`r`nTest mode enabled; no updates performed."
    }
}


#  BODY

Write-Host "`r`n`r`n**** Testing Mode ****"

If(Test-Path Variable:TestingMode){
    Write-Host "`r`nTesting Mode is enabled. No changes will be made to Lync."
}
Else{
    Write-Host "`r`nTesting Mode is NOT enabled. Lync contacts will be updated!!"
}

Write-Host "

**** Paths ****

The following paths will be used:

Scripts folder:  $ScriptsFolder
Backup folder:   $BackupFolder
Log folder:      $LogFolder
Working folder:  $WorkingFolder"

Write-Host "`r`n`r`n**** Front End Pool ****"

$LocalServer = "$env:COMPUTERNAME.$env:USERDNSDOMAIN".ToLower()

If(Test-Path Variable:EPSQLServer){
    $CSPool = (Get-CSComputer $LocalServer).Pool
    Write-Host "`r`nThe script will be run on Enterprise Front End server $LocalServer in the $CSPool pool using backend SQL server $EPSQLServer."
}
Else{
    Write-Host "`r`nThe script will be run on Standard Front End server $LocalServer."
}

Write-Host "`r`n`r`n**** Email Notifications ****"

If(Test-Path Variable:EmailEnabled){
    Write-Host "
Email notifications are enabled.  The following settings will be used:

Sender:        $EmailFrom
Recipient(s):  $EmailTo
SMTP server:   $EmailServer"
}
Else{
    Write-Host "`r`nEmail notifications are disabled."
}

Write-Host "`r`n`r`n**** Getting all SIP addresses ****"

$AllSipAddresses = Get-CsUser -Filter {Enabled -eq $True} | Select SipAddress | %{$_.SipAddress.Replace('sip:','')}

If(!$AllSipAddresses){
    Write-Host "`r`nNo enabled Lync users found.  Script will now terminate.`r`n"
    Stop-Transcript
    If($EmailEnabled){
        $EmailSubject = "The UpdateLyncContacts script has problems"
        $EmailBody = "The UpdateLyncContacts script did not find any enabled Lync users to process."
        Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -Body $EmailBody -SmtpServer $EmailServer -Attachments "$LogFolder\UpdateLyncContacts $DateTime.log"
    }
    Break
}

Write-Host "`r`nThere are $($AllSipAddresses.Count) SIP Addresses:`r`n"
$AllSipAddresses

Write-Host "`r`n`r`n**** Backing up all Lync contacts ****"

$AllSipAddresses | %{Dump-Contacts}

Write-Host "`r`n`r`n**** Filtering out users to exclude from processing ****"

If(Test-Path Variable:DontProcessUsers){
    Write-Host "`r`nThe following Lync users will be excluded from receiving missing contacts:`r`n"
    $DontProcessUsers
    $SipAddressesToProcess =  $AllSipAddresses | ?{$DontProcessUsers -notcontains $_}
}
Else{
    Write-Host "`r`nAll users will be processed."
    $SipAddressesToProcess =  $AllSipAddresses
}

Write-Host "`r`nList of users that will have their address book updated:`r`n"
$SipAddressesToProcess

Write-Host "`r`n`r`n**** Common Contacts ****"

If(Test-Path Variable:CommonContacts){
    Write-Host "`r`nCommon Contacts:`r`n"
    $CommonContacts
    Write-Host "`r`n"
    Write-Host 'Variable $DontAddUsers will be ignored'
    $SipAddressesToAdd =  $CommonContacts
}
Else{
    Write-Host "`r`nCommon Contacts not in use."
    Write-Host "`r`n`r`n**** Don't Add Users ****"

    If(Test-Path Variable:DontAddUsers){
        Write-Host "`r`nThe following Lync users will NOT be added to everyone's contacts:`r`n"
        $DontAddUsers
        $SipAddressesToAdd =  $AllSipAddresses | ?{$DontAddUsers -notcontains $_}
    }
    Else{
        Write-Host "`r`nAll missing users will be added."
        $SipAddressesToAdd =  $AllSipAddresses
    }
}
    
Write-Host "`r`nList of users that will be added to address books if they are missing:`r`n"
$SipAddressesToAdd

Write-Host "`r`n`r`n**** Processing users to determine missing contacts ****"

$SipAddressesToProcess | %{Process-Contacts}

Write-Host "`r`n`r`n**** Updating Lync users with missing contacts ****"

If(Test-Path -Path "$WorkingFolder\*" -Include "*.xml" -PathType Leaf){
    Get-ChildItem -Path "$WorkingFolder\*" -Include "*.xml" | %{Update-CSUsers}
    Write-Host "`r`nAll users successfully processed."
}
Else{
    Write-Host "`r`nNo Lync users required updates."
}

#  REPORTING

Write-Host "`r`n`r`nFinished...`r`n"

Stop-Transcript

If($EmailEnabled){
    $EmailSubject = "The UpdateLyncContacts script has completed"
    $EmailBody = "The UpdateLyncContacts script has completed running."
    Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -Body $EmailBody -SmtpServer $EmailServer -Attachments "$LogFolder\UpdateLyncContacts $DateTime.log"
}
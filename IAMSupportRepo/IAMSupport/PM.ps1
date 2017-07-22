# ===== Script to run each evening when IAM BH Support Desk Closes =====
# ===== Transfers IAM Support to the Scheduled After Hours Primary and Secondary IAM Consultants =====


# ===== Primary and Secondary variables below should match the Exchange Names of the AH Pri and Sec staff =====
$Primary = "Shelley Godden"
$Secondary = "Rob Canterbury"



# ===== Set the PrimaryMobile and SecondaryMobile variables to contain the Mobile Phone Numbers of the AH Pri and Sec staff =====
$user = Get-User "$Primary"
$PrimaryMobile = $user.MobilePhone
$user = Get-User "$Secondary"
$SecondaryMobile = $user.MobilePhone


# ===== Delete previous Error Log file if it exists =====
if (Test-Path "C:\Scripts\IAMSupport\ErrorLog.txt") {del "C:\Scripts\IAMSupport\ErrorLog.txt"}


# ===== Reset Error count and contents =====
$error.Clear()


# ===== Remove All Current Members from the IAM Support Email Groups =====
Get-DistributionGroupMember "IAM Support Primary Email" | Remove-DistributionGroupMember "IAM Support Primary Email" -Confirm:$False
Get-DistributionGroupMember "IAM Support Secondary Email" | Remove-DistributionGroupMember "IAM Support Secondary Email" -Confirm:$False
Get-DistributionGroupMember "IAM Support Escalation Email" | Remove-DistributionGroupMember "IAM Support Escalation Email" -Confirm:$False


# ===== Modify IAM Support Email groups to contain IAM AH Support Staff =====
Add-DistributionGroupMember -Identity "IAM Support Primary Email" -Member "$Primary" -Confirm:$False
Add-DistributionGroupMember -Identity "IAM Support Secondary Email" -Member "$Secondary" -Confirm:$False
Add-DistributionGroupMember -Identity "IAM Support Escalation Email" -Member "Darren Furlotte" -Confirm:$False


# ===== Modify IAM Support SMS Contacts to contain IAM AH Support Staff =====
Set-MailContact -Identity "IAM Support Primary SMS" -ExternalEmailAddress "$PrimaryMobile@sms.smscentral.com.au"
Set-MailContact -Identity "IAM Support Secondary SMS" -ExternalEmailAddress "$SecondaryMobile@sms.smscentral.com.au"


# ===== Display the changes made onto the screen, in case the user is running this script manually =====
Write-Host 
Write-Host IAM Support Primary Email ...
Get-DistributionGroupMember "IAM Support Primary Email"
Write-Host 
Write-Host 
Write-Host IAM Support Secondary Email ...
Write-Host 
Get-DistributionGroupMember "IAM Support Secondary Email"
Write-Host 
Write-Host 
Write-Host IAM Support Escalation Email ...
Write-Host 
Get-DistributionGroupMember "IAM Support Escalation Email"


# ===== Send email notifications =====
$PSEmailServer = "ow-exch-01.openwindows.local"
$mailbox = Get-Mailbox "$Primary"
$PRIemail = $mailbox.PrimarySMTPAddress
$mailbox = Get-Mailbox "$Secondary"
$SECemail = $mailbox.PrimarySMTPAddress
Send-MailMessage -From "rob.canterbury@openwindows.com.au" -To "IAMSupportTeam@openwindows.com.au", "$PRIemail", "$SECEmail" -Subject "IAM Support Notification" -Body "IAM Support has been handed over to $Primary and $Secondary."


# ===== Check for any errors and log them if they occurred =====
if ($error.count -ne 0) {$error | Out-File "C:\Scripts\IAMSupport\ErrorLog.txt"}
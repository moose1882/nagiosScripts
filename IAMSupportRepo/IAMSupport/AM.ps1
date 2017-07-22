# ===== Script to run each morning when IAM Business Hours Support Desk Opens =====
# ===== Transfers IAM Support to the IAM Business Hours (BH) Support Desk Staff =====


# ===== Primary and Secondary variables below should match the Exchange Names of the AH Pri and Sec staff =====
$Primary = "Shelley Godden"
$Secondary = "Rob Canterbury"


# ===== Delete previous Error Log file if it exists =====
if (Test-Path "C:\Scripts\IAMSupport\ErrorLog.txt") {del "C:\Scripts\IAMSupport\ErrorLog.txt"}


# ===== Reset Error count and contents =====
$error.Clear()


# ===== Remove All Current Members from the IAM Support Email Groups =====
Get-DistributionGroupMember "IAM Support Primary Email" | Remove-DistributionGroupMember "IAM Support Primary Email" -Confirm:$False
Get-DistributionGroupMember "IAM Support Secondary Email" | Remove-DistributionGroupMember "IAM Support Secondary Email" -Confirm:$False
Get-DistributionGroupMember "IAM Support Escalation Email" | Remove-DistributionGroupMember "IAM Support Escalation Email" -Confirm:$False


# ===== Modify IAM Support Email groups to contain IAM BH Support Staff =====
Add-DistributionGroupMember -Identity "IAM Support Primary Email" -Member "IAM Support Team" -Confirm:$False
Add-DistributionGroupMember -Identity "IAM Support Secondary Email" -Member "IAM Support Team" -Confirm:$False
Add-DistributionGroupMember -Identity "IAM Support Secondary Email" -Member "Product Support" -Confirm:$False
Add-DistributionGroupMember -Identity "IAM Support Escalation Email" -Member "IAM Support Team" -Confirm:$False
Add-DistributionGroupMember -Identity "IAM Support Escalation Email" -Member "Product Support" -Confirm:$False


# ===== Modify IAM Support SMS Contacts to contain IAM BH Support Staff =====

# ===== Primary BH SMS contact is Rob Canterbury =====
$PrimaryBHMobile = "0467400149"

# ===== Secondary BH SMS contact is Darren Furlotte =====
$SecondaryBHMobile = "0408550079"

Set-MailContact -Identity "IAM Support Primary SMS" -ExternalEmailAddress "$PrimaryBHMobile@sms.smscentral.com.au"
Set-MailContact -Identity "IAM Support Secondary SMS" -ExternalEmailAddress "$SecondaryBHMobile@sms.smscentral.com.au"


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
Send-MailMessage -From "rob.canterbury@openwindows.com.au" -To "IAMSupportTeam@openwindows.com.au", "$PRIemail", "$SECEmail" -Subject "IAM Support Notification" -Body "IAM Support has been handed back to the Business Hours Support Desk."


# ===== Check for any errors and log them if they occurred =====
if ($error.count -ne 0) {$error | Out-File "C:\Scripts\IAMSupport\ErrorLog.txt"}
Import-Module "C:\Program Files\Common Files\Microsoft Lync Server 2010\Modules\Lync\Lync.psd1"

Import-Module ActiveDirectory

Get-CsAdUser -LdapFilter "memberOf=CN=OWA Lync Enabled,OU=Security Groups,OU=Open Windows,DC=openwindows,DC=local" | Enable-CsUser -RegistrarPool "lync.openwindows.local" -SipAddressType SamAccountName -SipDomain openwindows.local

# ====================================================================
# Check certificates health state
# Author: Mathieu Chateau - LOTP
# mail: mathieu.chateau@lotp.fr
# version 0.1
# ====================================================================

#
# Require Set-ExecutionPolicy RemoteSigned.. or sign this script with your PKI 
#

# ============================================================
#
#  Do not change anything behind that line!
#
param 
(
	[bool]$checkMyStore=$true,
	[bool]$checkRootStore=$true,
	[bool]$checkCAStore=$true,
	[bool]$checkAuthRootStore=$true,
	[bool]$checkSharePointStore=$true,
	[int]$expireInDays=60,
	[int]$maxWarn = 1,
	[int]$maxError = 0
	
)

# blacklist all third party known expired certificates in root & co, on Windows Server 2003, 2008 & 2012
$blacklist=@(
"109F1CAED645BB78B3EA2B94C0697C740733031C",
"12519AE9CD777A560184F1FBD54215222E95E71F",
"127633A94F39CBF6EDF7C7BF64C4B535E9706E9A",
"18F7C1FCC3090203FD5BAA2F861A754976C8DD25",
"23EF3384E21F70F034C467D4CBA6EB61429F174E",
"245C97DF7514E7CF2DF8BE72AE957B9E04741E85",
"24A40A1F573643A67F0A4B0749F6A22BF28ABB6B",
"24BA6D6C8A5B5837A48DB5FAE919EA675C94D217",
"2B84BFBB34EE2EF949FE1CBE30AA026416EB2216",
"3A850044D8A195CD401A680C012CB0A3B5F8DC08",
"4463C531D7CCC1006794612BB656D3BF8257846F",
"47AFB915CDA26D82467B97FA42914468726138DD",
"4BA7B9DDD68788E12FF852E1A024204BF286A8F6",
"4D8547B7F864132A7F62D9B75B068521F10B68E3",
"4DF13947493CFF69CDE554881C5F114E97C3D03B",
"4EF2E6670AC9B5091FE06BE0E5483EAAD6BA32D9",
"4F65566336DB6598581D584A596C87934D5F2AB4",
"51C3247D60F356C7CA3BAF4C3F429DAC93EE7B74",
"53DECDF3BC1BDE7C9D1CEDAE718468CA20CC43E7",
"587B59FB52D8A683CBE1CA00E6393D7BB923BC92",
"5E997CA5945AAB75FFD14804A974BF2AE1DFE7E1",
"637162CC59A3A1E25956FA5FA8F60D2E1C52EAC6",
"6690C02B922CBD3FF0D0A5994DBD336592887E3F",
"67EB337B684CEB0EC2B0760AB488278CDD9597DD",
"687EC17E0602E3CD3F7DFBD7E28D57A0199A3F44",
"688B6EB807E8EDA5C7B17C4393D0795F0FAE155F",
"68ED18B309CD5291C0D3357C1D1141BF883866B1",
"720FC15DDC27D456D098FABF3CDD78D31EF5A8DA",
"7613BF0BA261006CAC3ED2DDBEF343425357F18B",
"7A74410FB0CD5C972A364B71BF031D88A6510E9E",
"7AC5FFF8DCBC5583176877073BF751735E9BD358",
"7B02312BACC59EC388FEAE12FD277F6A9FB4FAC1",
"7CA04FD8064C1CAA32A37AA94375038E8DF8DDC0",
"7D7F4414CCEF168ADF6BF40753B5BECD78375931",
"7F88CD7223F3C813818C994614A89C99FA3B5247",
"838E30F77FDD14AA385ED145009C0E2236494FAA",
"8977E8569D2A633AF01D0394851681CE122683A6",
"8B24CD8D8B58C6DA72ACE097C7B1E3CEA4DC3DC6",
"9078C5A28F9A4325C2A7C73813CDFE13C20F934E",
"90DEDE9E4C4E9F6FD88617579DD391BC65A68964",
"96974CD6B663A7184526B1D648AD815CF51E801A",
"9845A431D51959CAF225322B4A4FE9F223CE6D15",
"9BACF3B664EAC5A17BED08437C72E4ACDA12F7E7",
"9FC796E8F8524F863AE1496D381242105F1B78F5",
"A1505D9843C826DD67ED4EA5209804BDBB0DF502",
"A399F76F0CBF4C9DA55E4AC24E8960984B2905B6",
"A3E31E20B2E46A328520472D0CDE9523E7260C6D",
"A5EC73D48C34FCBEF1005AEB85843524BBFAB727",
"B19DD096DCD4E3E0FD676885505A672C438D4E9C",
"B533345D06F64516403C00DA03187D3BFEF59156",
"B6AF5BE5F878A00114C3D7FEF8C775C34CCD17B6",
"B72FFF92D2CE43DE0A8D4C548C503726A81E2B93",
"CFDEFE102FDA05BBE4C78D2E4423589005B2571D",
"D29F6C98BEFC6D986521543EE8BE56CEBC288CF3",
"DBAC3C7AA4254DA1AA5CAAD68468CB88EEDDEEA8",
"E38A2B7663B86796436D8DF5898D9FAA6835B238",
"EC0C3716EA9EDFADD35DFBD55608E60A05D3CBF3",
"EF2DACCBEABB682D32CE4ABD6CB90025236C07BC",
"F5A874F3987EB0A9961A564B669A9050F770308A",
"F88015D3F98479E1DA553D24FD42BA3F43886AEF")

$output=""
$outputNames=""
$countMyStore=0
$countRootStore=0
$countCAStore=0
$countAuthRootStore=0
$countSharePointStore=0
$countTotal=0

$allCerts=Get-ChildItem -Path cert: -Recurse | ? {
($_.Notafter -lt (get-date).AddDays($expireInDays)) -and 
($_.PSPParentPath -notmatch "Disallowed") -and
($blacklist -notcontains $_.Thumbprint)} | select NotAfter,FriendlyName,PSParentPath

function outputCert ($temp)
{
	$outputTemp=""
	foreach ($t in $temp)
	{
		$outputTemp+=$t.FriendlyName+":"+(get-date -Date $t.NotAfter -format "yyyy/MM/dd")+" "
	}
	return $outputTemp
}
# check params if provided

if($checkMyStore)
{
	$temp=@($allCerts | ? {$_.PSParentPath -match "\\My$"})
	$countMyStore=$temp.Count
	if($temp.Count -gt 0)
	{
		$outputNames+=outputCert $temp
	}
}
if($checkRootStore)
{
	$temp=@($allCerts | ? {$_.PSParentPath -match "\\Root$"})
	$countRootStore=$temp.Count
	if($temp.Count -gt 0)
	{
		$outputNames+=outputCert $temp
	}
}
if($checkCAStore)
{
	$temp=@($allCerts | ? {$_.PSParentPath -match "\\CA$"})
	$countCAStore=$temp.Count
	if($temp.Count -gt 0)
	{
		$outputNames+=outputCert $temp
	}
}
if($checkAuthRootStore)
{
	$temp=@($allCerts | ? {$_.PSParentPath -match "\\AuthRoot$"})
	$countAuthRootStore=$temp.Count
	if($temp.Count -gt 0)
	{
		$outputNames+=outputCert $temp
	}
}
if($checkSharePointStore)
{
	$temp=@($allCerts | ? {$_.PSParentPath -match "\\SharePoint$"})
	$countSharePointStore=$temp.Count
	if($temp.Count -gt 0)
	{
		$outputNames+=outputCert $temp
	}
}

foreach ($var in (Get-Variable -Name "count*Store"))
{
	$countTotal+=$($var).Value
}

if($countTotal -gt $maxError)
{
	$state="CRITICAL"
	$exitcode=2
}
elseif($countTotal -gt $maxWarn)
{
	$state="WARNING"
	$exitcode=1
}
else
{
	$state="OK"
	$exitcode=0
}
$output=$state+": "+$outputNames
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup($output)
Write-Host $output
exit $exitcode
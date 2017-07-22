# Put your host names here
all_hosts = [ 'localhost']

snmp_default_community = "public_OMD"
checks = [
 ( 'IDAAS-JSS-01', 'services', 'IdentityManagerService', None ),
 # some other checks...
]

inventory_services = ['IISADMIN', 'AppHostSvc', 'W3SVC', 'VMMService' ] 

#Raising the threshold for Memory checks to try and suppress Mem issues with SQL
#not done here but via WATO
#check_parameters += [
# ( { "levels" : (97.0, 99.0)} , ALL_HOSTS, ["Memory and pagefile"] ),
#]

#an algorithm for "magic" adaption of percentage levels for especially large or small filesystems. 
#The algorithm uses the so called df magic number as a parameter to adjust the amount of adaption. 
# a value of .8 is average and normSize is in GB
filesystem_default_levels["magic"] = 0.5
filesystem_default_levels["magic_normsize"] = 20


# ignore Check_MK inventory for hosts that I can't connect to yet
ignored_services = [
  ( [ "AP1", "AP2", "AP3", "gw-172-31-172-93", "HelpDeskPilot", "OW-IAM-01" ], [ "Check_MK inventory" ] )
]


# ignored log files entries on windows hosts
logwatch_patterns = {
'System': [
#( 'I', 'Schannel*' ),
#( 'W', '*UmrdpService*'),
#( 'I', 'KDC*'),
],
'Operations Manager': [
( 'I', '' ),
],
#'VM Manager': [
#( 'I', '' ),
#],
'Application': [
( 'I', '' ),
],
'Security': [
#( 'C', '*Logon Failure*'),
( 'I', '' ),
],
#'Active Directory Web Services': [
# ( 'I', ''),
#],
'DFS Replication': [
( 'I', ''),
],
#'DNS Server': [
#( 'I', ''),
#],
#'VisualSVNServer': [
#( 'I', ''),
#],
#'Directory Service': [
#( 'I', ''),
#],
#'MSExchange Management': [
#( 'I', ''),
#]
}


# Put your host names here
# all_hosts = [ 'localhost' ]
all_hosts = [ ]

#checks = [
# ( 'IDAAS-JSS-01', 'services', 'IdentityManagerService', None ),
# # some other checks...
#]

inventory_services = ['IISADMIN', 'AppHostSvc', 'W3SVC', 'CloudAccessManagerProxy', 'IdentityManagerService', 'MpsSvc' ] 

#Raising the threshold for Memory checks to try and suppress Mem issues with SQL
#not done here but via WATO
check_parameters += [
 ( { "levels" : (97.0, 99.0)} , ALL_HOSTS, ["Memory and pagefile"] ),
 ]

#an algorithm for "magic" adaption of percentage levels for especially large or small filesystems. 
#The algorithm uses the so called df magic number as a parameter to adjust the amount of adaption. 
# a value of .8 is average and normSize is in GB
filesystem_default_levels["magic"] = 0.5
filesystem_default_levels["magic_normsize"] = 20

# ignored log files entries on windows hosts
logwatch_patterns = {

'System': [
( 'I', '' ),
],

'Operations Manager': [
( 'I', '' ),
],

'VM Manager': [
( 'I', '' ),
],

'Application': [
( 'I', '' ),
],

'Security': [
( 'I', '' ),
],

'Active Directory Web Services': [
 ( 'I', ''),
],

'DFS Replication': [
( 'I', ''),
],

'DNS Server': [
( 'I', ''),
],

'VisualSVNServer': [
( 'I', ''),
],

'Directory Service': [
( 'I', ''),
],

'MSExchange Management': [
( 'I', ''),
]
}


# Put your host names here
# all_hosts = [ 'localhost' ]
all_hosts = [ ]

checks = [
 ( 'JSS-02', 'services', 'IdentityManagerService', None ),
 ( 'IDaaS-AD-01', 'services', 'OWPassServer', None),
 ( 'IDaaS-AD-01', 'services', 'ADAM_IDaaS-LDAP', None),
 # some other checks...
]

####
### Thresholds for File Group Checks. Specifically JobService.log on D1IM server
####

#check_parameters = [
#    ({
#       "minsize": (200.0, 300.0),
#       "maxsize": (400.0, 500.0),
#       "mincount": (2, 3),
#       "maxcount": (3, 4),
#       "minage_oldest": (50, 60),
#       "maxage_oldest": (100, 120),
#       "minage_newest": (10, 20),
#       "maxage_newest": (30, 40),
#       "minsize_largest": (2048, 1024),
#       "maxsize_largest": (2048, 1024),
#       "minsize_largest": (10240, 20480),
#       "maxsize_largest": (10240, 20480),
#     }, 'IDaaS-D1IM-01', ["JobService_logs"]),
# ]
 
inventory_services = ['IISADMIN', 'AppHostSvc', 'W3SVC', 'VMMService', 'SMTPSVC', 'IdentityManagerService' ] 

#an algorithm for "magic" adaption of percentage levels for especially large or small filesystems. 
#The algorithm uses the so called df magic number as a parameter to adjust the amount of adaption. 
# a value of .8 is average and normSize is in GB
filesystem_default_levels["magic"] = 0.5
filesystem_default_levels["magic_normsize"] = 30
tcp_connect_timeout = 10.0

# ignore Check_MK inventory for hosts that I can't connect to yet
ignored_services = [
  ( [ "gw-172-31-172-90", "gw-172-31-172-93"  ], [ "Check_MK inventory" ] )
]
# ignored log files entries on windows hosts
logwatch_patterns = {
#'System': [
#( 'I', 'Schannel*' ),
#( 'I', '*UmrdpService*'),
#( 'I', 'KDC*'),
#],
#'Operations Manager': [
#( 'I', '' ),
#],
#'VM Manager': [
#( 'I', '' ),
#],
#'Application': [
#( 'I', '' ),
#],
'Security': [
#( 'C', '*Logon Failure*'),
( 'I', '' ),
],
#'Active Directory Web Services': [
# ( 'I', ''),
#],
#'DFS Replication': [
#( 'I', ''),
#],
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
#],

}
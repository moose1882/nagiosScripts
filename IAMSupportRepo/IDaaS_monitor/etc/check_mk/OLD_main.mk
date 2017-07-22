# Put your host names here
# all_hosts = [ 'localhost' ]
all_hosts = [ ]

checks = [
 ( 'JSS-02', 'services', 'IdentityManagerService', None ),
 ( 'IDaaS-AD-01', 'services', 'OWPassServer', None),
 # some other checks...
]

inventory_services = ['IISADMIN', 'AppHostSvc', 'W3SVC', 'VMMService', 'SMTPSVC', 'IdentityManagerService' ] 

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
#'Security': [
#( 'C', '*Logon Failure*'),
#( 'I', '' ),
#],
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
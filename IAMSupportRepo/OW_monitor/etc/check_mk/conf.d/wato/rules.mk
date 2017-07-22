# Written by WATO
# encoding: utf-8


service_contactgroups = [
  ( 'AHChangeOver', [], ALL_HOSTS, ['AHscript_error'] ),
] + service_contactgroups


active_checks.setdefault('smtp', [])

active_checks['smtp'] = [
  ( (u'mail.openwindows.com.au', {'ip_version': 'ipv4', 'cert_days': 30, 'auth': ('darren.furlotte', '11 Goodwin'), 'starttls': True}), [], ['ow-exch-01'] ),
] + active_checks['smtp']


service_groups = [
  ( 'LOGS', [], ALL_HOSTS, ['LOG'] ),
  ( 'PING', [], ALL_HOSTS, ['PING'] ),
  ( 'DiskSpace', [], ALL_HOSTS, ['fs_'] ),
  ( 'Memory_PageFile', [], ALL_HOSTS, ['Memory and pagefile'] ),
  ( 'SQLServices', [], ALL_HOSTS, ['SQL', 'MSSQL'] ),
  ( 'Printers', [], ALL_HOSTS, ['Printer'] ),
  ( 'custom_checks', [], ALL_HOSTS, ['zdrive*', 'AHC*', 'service_'] ),
  ( 'IIS_Admin', [], ALL_HOSTS, ['service_IISADMIN', 'AppHostSvc', 'W3SVC'] ),
  ( 'HTTP', [], ALL_HOSTS, ['HTTP*'] ),
] + service_groups


extra_service_conf.setdefault('notification_options', [])

extra_service_conf['notification_options'] = [
  ( 'c,r', [], ALL_HOSTS, ALL_SERVICES ),
] + extra_service_conf['notification_options']


checkgroup_parameters.setdefault('cisco_mem', [])

checkgroup_parameters['cisco_mem'] = [
  ( (90.0, 97.0), [], ['192.168.1.35'], ['I/O$'] ),
] + checkgroup_parameters['cisco_mem']


extra_host_conf.setdefault('flap_detection_enabled', [])

extra_host_conf['flap_detection_enabled'] = [
  ( '0', [], ALL_HOSTS ),
] + extra_host_conf['flap_detection_enabled']


checkgroup_parameters.setdefault('mailqueue_length', [])

checkgroup_parameters['mailqueue_length'] = [
  ( (10, 15), ['LinuxSRV', ], ['OW-OMD-01'], {'comment': u'While testing notification'} ),
] + checkgroup_parameters['mailqueue_length']


if only_hosts == None:
    only_hosts = []

only_hosts = [
  ( ['!offline', ], ALL_HOSTS, {'comment': u'Do not monitor hosts with the tag "offline"'} ),
] + only_hosts


extra_host_conf.setdefault('notifications_enabled', [])

extra_host_conf['notifications_enabled'] = [
  ( '0', [], ['SANJAY', 'MANJULA'], {'disabled': True} ),
] + extra_host_conf['notifications_enabled']


checkgroup_parameters.setdefault('fileinfo-groups', [])

checkgroup_parameters['fileinfo-groups'] = [
  ( {'minsize': (5, 1), 'mincount': (10, 1), 'maxsize': (1073741824, 5368709120), 'maxcount': (100, 1000)}, [], ['OW-FSS-01'], ['MYOB'] ),
] + checkgroup_parameters['fileinfo-groups']


ignored_services = [
  ( NEGATE, [], ['AUDB1'], ['NTP Time$'] ),
] + ignored_services


host_groups = [
  ( 'ANNETTE', [], ['HelpdeskPilot', 'ANNETTE'] ),
  ( 'APU', [], ['Internal', 'OW-FSS-01', 'SugarCRM', 'APU'] ),
  ( 'HOMER', [], ['Support', 'HOMER'] ),
  ( 'MANJULA', [], ['Certificates', 'OW-OBJ-01', 'MANJULA'] ),
  ( 'SANJAY', [], ['QW-SQL-01', 'SANJAY'] ),
  ( 'SYSADMIN', [], ['OW-ADS-01', 'OW-FSS-01', 'OW-OBJ-01', 'OW-ADS-02', 'HelpDeskPilot', 'OW-SQL-01'] ),
  ( 'Wireless', ['wifi-01', ], ALL_HOSTS ),
  ( 'Active_Directory', [], ['OW-ADS-01', 'OW-ADS-02', 'OW-ADS-03'], {'comment': u'Active Directory Group'} ),
  ( 'vm_hosts', [], ['HOMER', 'SANJAY', 'MANJULA', 'APU'] ),
  ( 'IDaaS', [], ['IDAAS-JSS-01', 'IDAAS-ADS-01'], {'comment': u'IDaaS POC'} ),
] + host_groups


host_contactgroups = [
  ( 'all', [], ALL_HOSTS, {'comment': u'Put all hosts into the contact group "all"'} ),
] + host_contactgroups


logwatch_rules = [
  ( [('I', 'KDC', '')], [], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'MSExchange_CmdletLogs', '')], ['cmk-agent', ], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'VDS_Basic_Provider', '')], ['WINsrv', ], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'NTDS_LDAP', '')], ['cmk-agent', ], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'Microsoft-Windows-Time-Service', '')], ['cmk-agent', ], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'Microsoft-Windows-GroupPolicy', '')], ['cmk-agent', ], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'Schannel', '')], ['cmk-agent', ], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'DCOM', '')], ['cmk-agent', ], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'UmrdpService', '')], ['cmk-agent', ], ALL_HOSTS, ALL_SERVICES ),
  ( [('O', 'Veeam_Backup The operation completed successfully.', '')], ['cmk-agent', ], ALL_HOSTS, ALL_SERVICES ),
  ( [('O', 'has finished with Warning state', '')], ['cmk-agent', ], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'DCOM machine-default', '')], [], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'LsaSrv', '')], [], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'IPBOOTP', '')], [], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'BROWSER', '')], [], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', '0.5807', '')], [], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'The directory cannot be removed', '')], [], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'The system cannot find the device specified', '')], [], ALL_HOSTS, ALL_SERVICES ),
] + logwatch_rules


extra_host_conf.setdefault('notification_period', [])

extra_host_conf['notification_period'] = [
  ( 'AEST_BH', [], ALL_HOSTS ),
] + extra_host_conf['notification_period']


static_checks.setdefault('msx_queues', [])

static_checks['msx_queues'] = [
  ( ('winperf_msx_queues', 'Retry Remote Delivery', (5, 10)), [], ['ow-exch-01'] ),
] + static_checks['msx_queues']


checkgroup_parameters.setdefault('filesystem', [])

checkgroup_parameters['filesystem'] = [
  ( {'trend_perfdata': True}, [], ['HOMER'], ['E://'] ),
] + checkgroup_parameters['filesystem']


bulkwalk_hosts = [
  ( ['!snmp-v1', ], ALL_HOSTS, {'comment': u'Hosts with the tag "snmp-v1" must not use bulkwalk'} ),
] + bulkwalk_hosts


static_checks.setdefault('omd_status', [])

static_checks['omd_status'] = [
  ( ('omd_status', 'ow_monitor', None), [], ['localhost'], {'disabled': True} ),
  ( ('omd_status', 'BkUp_ow_monitor', None), [], ['localhost'], {'disabled': True} ),
] + static_checks['omd_status']


extra_service_conf.setdefault('flap_detection_enabled', [])

extra_service_conf['flap_detection_enabled'] = [
  ( '0', [], ALL_HOSTS, ALL_SERVICES ),
] + extra_service_conf['flap_detection_enabled']


active_checks.setdefault('http', [])

active_checks['http'] = [
  ( (u'SugarCRM', {'uri': 'http://sugarcrm:8080/sugarcrm659'}), [], ['SugarCRM'] ),
  ( (u'Support Portal', {'uri': 'http://support.openwindows.com.au/', 'auth': ('darren.furlotte', '11 Goodwin')}), [], ['HelpDeskPilot'] ),
] + active_checks['http']


extra_host_conf.setdefault('notification_options', [])

extra_host_conf['notification_options'] = [
  ( 'd,u,r', [], ALL_HOSTS ),
] + extra_host_conf['notification_options']


checkgroup_parameters.setdefault('memory_pagefile_win', [])

checkgroup_parameters['memory_pagefile_win'] = [
  ( {'pagefile': (90.0, 95.0), 'memory': (97.0, 99.0)}, ['lan', ], ALL_HOSTS, {'comment': u'Modified Mem and Page File levels to reflect massive SQL Mem issues'} ),
] + checkgroup_parameters['memory_pagefile_win']


extra_service_conf.setdefault('notification_period', [])

extra_service_conf['notification_period'] = [
  ( 'AEST_BH', [], ALL_HOSTS, ALL_SERVICES ),
] + extra_service_conf['notification_period']


extra_service_conf.setdefault('notifications_enabled', [])

extra_service_conf['notifications_enabled'] = [
  ( '0', [], ALL_HOSTS, ['System Updates'] ),
] + extra_service_conf['notifications_enabled']


ping_levels = [
  ( {'loss': (80.0, 100.0), 'packets': 6, 'timeout': 20, 'rta': (1500.0, 3000.0)}, ['wan', ], ALL_HOSTS, {'comment': u'Allow longer round trip times when pinging WAN hosts'} ),
] + ping_levels


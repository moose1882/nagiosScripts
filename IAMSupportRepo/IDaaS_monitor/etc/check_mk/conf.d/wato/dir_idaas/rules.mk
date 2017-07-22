# Written by WATO
# encoding: utf-8


service_groups = [
  ( 'IIS', ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ['service_IISADMIN'] ),
  ( 'SQL_File_Size', ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ['.* File Sizes'] ),
  ( 'LogFiles', ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ['LOG'], {'disabled': True} ),
  ( 'sql_backup', ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ['MSSQLSERVER .* Backup'] ),
  ( 'tcp_6556', ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ['TCP Port 6556'] ),
  ( 'dell_logs', ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ['LOG QPM - Quest One Password Manager', 'LOG Dell One Identity Cloud Access Manager', '.*JobService.log', '.*Q1IMService.log'] ),
  ( 'services_', ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ['service_*'] ),
] + service_groups


checkgroup_parameters.setdefault('systemtime', [])

checkgroup_parameters['systemtime'] = [
  ( (50, 65), ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, {'comment': u'50/60 sec offset'} ),
] + checkgroup_parameters['systemtime']


host_groups = [
  ( 'app_layer', ['/' + FOLDER_PATH + '/+'], ['IDaaS-D1IM-01', 'IDaas-AD-01', 'IDaaS-CAM-01'] ),
  ( 'pres_layer', ['/' + FOLDER_PATH + '/+'], ['IDaaS-Proxy-01', 'IDaaS-NAT-01', 'IDaaS-WSUS'] ),
  ( 'data_layer', ['/' + FOLDER_PATH + '/+'], ['IDaaS-SQL-02'] ),
] + host_groups


logwatch_rules = [
  ( [('I', '4624', ''), ('I', 'An account was successfully logged on', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'Schannel', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'The volume for a file has been externally altered so that the opened file is no longer valid.', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'UmrdpService', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'ASP.NET_2.0', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'semaphore', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('O', 'did not have a client value in the company attribute.', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'NTDS_LDAP', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'JobService The operation completed successfully', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('O', '0.0 JobService_Logger', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'Software_Protection_Platform_Service', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'user registry handles leaked from', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'An account was successfully logged on', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'Special privileges assigned to new logon', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'did not have a client value in the company attribute.', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'demo_*', ''), ('I', 'DEMO_*', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('O', 'The process cannot access the file', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
  ( [('I', 'There is not enough space on the disk', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
] + logwatch_rules


active_checks.setdefault('http', [])

active_checks['http'] = [
  ( (u'CAM App Portal-LogIn', {'ssl': True, 'uri': '/CloudAccessManager/UI/Go', 'auth': ('Cloud\\daz', '11 Goodwin')}), ['cmk-agent', '/' + FOLDER_PATH + '/+'], ['IDaaS-CAM-01'] ),
  ( (u'CAM App Portal-RespTime', {'ssl': True, 'response_time': (500.0, 750.0)}), ['cmk-agent', '/' + FOLDER_PATH + '/+'], ['IDaaS-CAM-01'] ),
  ( (u'CAM App Portal - Cert', {'cert_days': 120, 'sni': True}), ['cmk-agent', '/' + FOLDER_PATH + '/+'], ['IDaaS-CAM-01'] ),
  ( (u'https://owc.cloud.openwindows.com.au', {'uri': '/IdentityManager/page.axd', 'auth': ('Cloud\\Daz', '11 Goodwin'), 'onredirect': 'follow'}), ['/' + FOLDER_PATH + '/+'], ['IDaaS-CAM-01'] ),
] + active_checks['http']


checkgroup_parameters.setdefault('memory_pagefile_win', [])

checkgroup_parameters['memory_pagefile_win'] = [
  ( {'memory': (90.0, 95.0), 'pagefile': (70.0, 90.0)}, ['/' + FOLDER_PATH + '/+'], ALL_HOSTS ),
] + checkgroup_parameters['memory_pagefile_win']


active_checks.setdefault('dns', [])

active_checks['dns'] = [
  ( ('cloud.openwindows.com.au', {'expected_authority': True, 'expected_address': '10.0.2.20', 'server': '10.0.2.20'}), ['/' + FOLDER_PATH + '/+'], ALL_HOSTS ),
] + active_checks['dns']


active_checks.setdefault('tcp', [])

active_checks['tcp'] = [
  ( (6556, {'refuse_state': 'crit'}), ['/' + FOLDER_PATH + '/+'], ALL_HOSTS ),
] + active_checks['tcp']


active_checks.setdefault('mkevents', [])

active_checks['mkevents'] = [
  ( {'hostspec': '$HOSTNAME$'}, ['/' + FOLDER_PATH + '/+'], ['IDaaS-AD-01'] ),
] + active_checks['mkevents']


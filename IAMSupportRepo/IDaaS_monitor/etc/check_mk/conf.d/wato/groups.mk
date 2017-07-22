# Written by WATO
# encoding: utf-8

if type(define_hostgroups) != dict:
    define_hostgroups = {}
define_hostgroups.update({'app_layer': u'Application Layer',
 'data_layer': u'Data Layer',
 'pres_layer': u'Presentation Layer'})

if type(define_servicegroups) != dict:
    define_servicegroups = {}
define_servicegroups.update({'IIS': u'IIS',
 'LogFiles': u'LogFiles',
 'SQL_File_Size': u'SQL File Sizes',
 'dell_logs': u'DellOne Logs',
 'services_': u'Custom Services',
 'sql_backup': u'SQL Backup',
 'tcp_6556': u'Monitor Port'})

if type(define_contactgroups) != dict:
    define_contactgroups = {}
define_contactgroups.update({'all': u'Everybody'})


# Written by WATO
# encoding: utf-8

if type(define_hostgroups) != dict:
    define_hostgroups = {}
define_hostgroups.update({'ANNETTE': u'ANNETTE',
 'APU': u'APU',
 'Active_Directory': u'Active Directory',
 'HOMER': u'HOMER',
 'IDaaS': u'IDaaS',
 'MANJULA': u'MANJULA',
 'SANJAY': u'SANJAY',
 'SYSADMIN': u'SYSADMIN',
 'Wireless': u'Wireless',
 'vm_hosts': u'Hyper-V Hosts'})

if type(define_servicegroups) != dict:
    define_servicegroups = {}
define_servicegroups.update({'DiskSpace': u'Disk Space',
 'HTTP': u'Internal Web Portals',
 'IIS_Admin': u'IIS_Admin',
 'LOGS': u'LOGS',
 'Memory_PageFile': u'Memory and Pagefile',
 'PING': u'PING',
 'Printers': u'Printers',
 'SQLServices': u'SQL',
 'custom_checks': u'Custom Checks'})

if type(define_contactgroups) != dict:
    define_contactgroups = {}
define_contactgroups.update({'AHChangeOver': u'AHChangeOver',
 'Z_DriveDelete': u'Purge Z Drive Share',
 'all': u'SYSAdmin',
 'grp_IDaaS': u'grp_IDaaS'})


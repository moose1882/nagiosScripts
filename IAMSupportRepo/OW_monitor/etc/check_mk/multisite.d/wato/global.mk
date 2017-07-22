# Written by WATO
# encoding: utf-8

ldap_cache_livetime = 604800
pagetitle_date_format = 'dd.mm.yyyy'
wato_max_snapshots = 5
ldap_active_plugins = {'alias': {'attr': 'cn'}, 'auth_expire': {}, 'email': {'attr': 'mail'}}
start_url = 'dashboard.py'
ldap_connection = {'bind': ('Global_monitoring', '0p3nW1nd0w5'),
 'connect_timeout': 2.0,
 'page_size': 1000,
 'port': 389,
 'server': '10.0.2.20',
 'type': 'ad',
 'version': 3}
save_user_access_times = True
multisite_draw_ruleicon = True
ldap_debug_log = '/omd/sites/ow_monitor/var/check_mk/web/ldap-debug.log'
ldap_groupspec = {'dn': '', 'filter': '(objectclass=group)', 'scope': 'sub'}
ldap_userspec = {'dn': 'OU=Users,OU=Global,OU=Resources,DC=cloud,DC=openwindows,DC=com,DC=au',
 'scope': 'sub',
 'user_id_umlauts': 'replace'}
debug = False
page_heading = u'OWA - NOC'
user_connectors = ['htpasswd']
wato_hide_hosttags = False
wato_hide_filenames = False

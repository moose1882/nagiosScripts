# Written by WATO
# encoding: utf-8

ldap_cache_livetime = 300
wato_max_snapshots = 5
ldap_active_plugins = {'alias': {'attr': 'cn'}, 'email': {'attr': 'mail'}}
ldap_connection = {'bind': ('Global_monitoring', '0p3nW1nd0w5'),
 'connect_timeout': 2.0,
 'page_size': 1000,
 'port': 389,
 'server': '10.0.2.20',
 'type': 'ad',
 'version': 3}
ldap_debug_log = None
mkeventd_pprint_rules = True
ldap_groupspec = {'dn': '', 'scope': 'sub'}
ldap_userspec = {'dn': 'OU=Users,OU=Global,OU=Resources,DC=cloud,DC=openwindows,DC=com,DC=au',
 'scope': 'sub',
 'user_id_umlauts': 'replace'}
multisite_draw_ruleicon = True
user_connectors = ['htpasswd', 'ldap']
save_user_access_times = True
table_row_limit = 25
sidebar_notify_interval = 60.0

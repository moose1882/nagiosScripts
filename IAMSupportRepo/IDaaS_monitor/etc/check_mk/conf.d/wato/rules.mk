# Written by WATO
# encoding: utf-8


if only_hosts == None:
    only_hosts = []

only_hosts = [
  ( ['!offline', ], ALL_HOSTS, {'comment': u'Do not monitor hosts with the tag "offline"'} ),
] + only_hosts


static_checks.setdefault('threads', [])

static_checks['threads'] = [
  ( ('cpu.threads', None, (1000, 2000)), [], ['!localhost'] + ALL_HOSTS, {'disabled': True} ),
] + static_checks['threads']


host_contactgroups = [
  ( 'all', [], ALL_HOSTS, {'comment': u'Put all hosts into the contact group "all"'} ),
] + host_contactgroups


bulkwalk_hosts = [
  ( ['!snmp-v1', ], ALL_HOSTS, {'comment': u'Hosts with the tag "snmp-v1" must not use bulkwalk'} ),
] + bulkwalk_hosts


static_checks.setdefault('disk_io', [])

static_checks['disk_io'] = [
  ( ('winperf_phydisk', 'SUMMARY', {'read': None, 'write': None, 'read_ql': (80.0, 90.0), 'latency': (80.0, 160.0), 'write_ql': (80.0, 90.0)}), ['1', ], ['!localhost', '!IDaaS-NAT-01'] + ALL_HOSTS, {'disabled': True} ),
] + static_checks['disk_io']


checkgroup_parameters.setdefault('disk_io', [])

checkgroup_parameters['disk_io'] = [
  ( {'read': None}, ['2', ], ['IDaaS-NAT-01'], ALL_SERVICES ),
] + checkgroup_parameters['disk_io']


static_checks.setdefault('omd_status', [])

static_checks['omd_status'] = [
  ( ('omd_status', 'idaas', None), [], ['localhost'] ),
] + static_checks['omd_status']


ping_levels = [
  ( {'loss': (80.0, 100.0), 'packets': 6, 'timeout': 20, 'rta': (1500.0, 3000.0)}, ['wan', ], ALL_HOSTS, {'comment': u'Allow longer round trip times when pinging WAN hosts'} ),
] + ping_levels


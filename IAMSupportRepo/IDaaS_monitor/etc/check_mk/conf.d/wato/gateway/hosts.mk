# Written by WATO
# encoding: utf-8

all_hosts += [
  "gw-172-31-172-90|2|snmp-only|prod|snmp|lan|wato|/" + FOLDER_PATH + "/",
  "gw-172-31-172-93|2|cmk-agent|prod|lan|tcp|wato|/" + FOLDER_PATH + "/",
]

# Explicit IP addresses
ipaddresses.update({'gw-172-31-172-90': u'172.31.172.90', 'gw-172-31-172-93': u'172.31.172.93'})


# Settings for alias
extra_host_conf.setdefault('alias', []).extend(
  [(u'OWs Internet Gateway', ['gw-172-31-172-90']),
 (u'Created by parent scan', ['gw-172-31-172-93'])])

# Settings for parents
extra_host_conf.setdefault('parents', []).extend(
  [('localhost', ['gw-172-31-172-90']), ('localhost', ['gw-172-31-172-93'])])

# Host attributes (needed for WATO)
host_attributes.update(
{'gw-172-31-172-90': {'alias': u'OWs Internet Gateway',
                      'ipaddress': u'172.31.172.90',
                      'parents': ['localhost'],
                      'tag_OS': '2',
                      'tag_agent': 'snmp-only',
                      'tag_criticality': 'prod'},
 'gw-172-31-172-93': {'alias': u'Created by parent scan',
                      'ipaddress': u'172.31.172.93',
                      'tag_OS': '2',
                      'tag_agent': 'cmk-agent',
                      'tag_criticality': 'prod'}})

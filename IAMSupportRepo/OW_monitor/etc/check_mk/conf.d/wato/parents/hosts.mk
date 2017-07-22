# Written by WATO
# encoding: utf-8

all_hosts += [
  "ANNETTE|cmk-agent|prod|lan|tcp|WINsrv|wato|/" + FOLDER_PATH + "/",
  "APU|cmk-agent|prod|lan|tcp|WINsrv|wato|/" + FOLDER_PATH + "/",
  "HOMER|cmk-agent|prod|lan|tcp|WINsrv|wato|/" + FOLDER_PATH + "/",
  "MANJULA|cmk-agent|prod|lan|tcp|WINsrv|wato|/" + FOLDER_PATH + "/",
  "SANJAY|cmk-agent|prod|lan|tcp|WINsrv|wato|/" + FOLDER_PATH + "/",
  "gw-172-31-172-93|cmk-agent|prod|lan|tcp|WINsrv|wato|/" + FOLDER_PATH + "/",
]

# Explicit IP addresses
ipaddresses.update({'ANNETTE': u'192.168.1.144',
 'APU': u'192.168.1.76',
 'HOMER': u'192.168.1.21',
 'MANJULA': u'192.168.1.104',
 'SANJAY': u'192.168.1.111',
 'gw-172-31-172-93': u'172.31.172.93'})


# Settings for alias
extra_host_conf.setdefault('alias', []).extend(
  [(u'Created by parent scan', ['gw-172-31-172-93'])])

# Host attributes (needed for WATO)
host_attributes.update(
{'ANNETTE': {'ipaddress': u'192.168.1.144'},
 'APU': {'ipaddress': u'192.168.1.76'},
 'HOMER': {'ipaddress': u'192.168.1.21', 'tag_criticality': 'prod'},
 'MANJULA': {'ipaddress': u'192.168.1.104'},
 'SANJAY': {'ipaddress': u'192.168.1.111'},
 'gw-172-31-172-93': {'alias': u'Created by parent scan',
                      'inventory_failed': True,
                      'ipaddress': u'172.31.172.93',
                      'tag_agent': 'cmk-agent'}})

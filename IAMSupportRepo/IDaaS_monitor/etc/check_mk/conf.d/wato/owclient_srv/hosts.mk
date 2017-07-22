# Written by WATO
# encoding: utf-8

all_hosts += [
  "JSS-02|1|cmk-agent|prod|lan|tcp|wato|/" + FOLDER_PATH + "/",
  "OW-ADS-01|1|wan|cmk-agent|prod|tcp|wato|/" + FOLDER_PATH + "/",
  "OW-ADS-02|1|wan|cmk-agent|prod|tcp|wato|/" + FOLDER_PATH + "/",
  "OW-ADS-03|1|wan|cmk-agent|prod|tcp|wato|/" + FOLDER_PATH + "/",
]

# Explicit IP addresses
ipaddresses.update({'JSS-02': u'192.168.1.64',
 'OW-ADS-01': u'192.168.1.4',
 'OW-ADS-02': u'192.168.1.6',
 'OW-ADS-03': u'172.26.54.110'})


# Settings for alias
extra_host_conf.setdefault('alias', []).extend(
  [(u'Primary AD', ['OW-ADS-01']),
 (u'BA private cloud AD', ['OW-ADS-03']),
 (u'Secondary AD', ['OW-ADS-02']),
 (u'OWC JSS', ['JSS-02'])])

# Settings for parents
extra_host_conf.setdefault('parents', []).extend(
  [('gw-172-31-172-93', ['OW-ADS-03']), ('gw-172-31-172-90', ['JSS-02'])])

# Host attributes (needed for WATO)
host_attributes.update(
{'JSS-02': {'alias': u'OWC JSS',
            'ipaddress': u'192.168.1.64',
            'parents': ['gw-172-31-172-90'],
            'tag_OS': '1',
            'tag_networking': 'lan'},
 'OW-ADS-01': {'alias': u'Primary AD',
               'ipaddress': u'192.168.1.4',
               'tag_networking': 'wan'},
 'OW-ADS-02': {'alias': u'Secondary AD',
               'inventory_failed': True,
               'ipaddress': u'192.168.1.6',
               'tag_networking': 'wan'},
 'OW-ADS-03': {'alias': u'BA private cloud AD',
               'ipaddress': u'172.26.54.110',
               'parents': ['gw-172-31-172-93'],
               'tag_networking': 'wan'}})

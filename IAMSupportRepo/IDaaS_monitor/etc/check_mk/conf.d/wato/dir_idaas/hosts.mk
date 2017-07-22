# Written by WATO
# encoding: utf-8

all_hosts += [
  "IDaaS-AD-01|1|wan|cmk-agent|critical|tcp|wato|/" + FOLDER_PATH + "/",
  "IDaaS-CAM-01|1|wan|cmk-agent|critical|tcp|wato|/" + FOLDER_PATH + "/",
  "IDaaS-D1IM-01|1|wan|cmk-agent|critical|tcp|wato|/" + FOLDER_PATH + "/",
  "IDaaS-NAT-01|2|wan|cmk-agent|critical|tcp|wato|/" + FOLDER_PATH + "/",
  "IDaaS-Proxy-01|1|wan|cmk-agent|critical|tcp|wato|/" + FOLDER_PATH + "/",
  "IDaaS-SQL-02|1|wan|cmk-agent|critical|tcp|wato|/" + FOLDER_PATH + "/",
  "IDaaS-WSUS|1|wan|cmk-agent|critical|tcp|wato|/" + FOLDER_PATH + "/",
]

# Explicit IP addresses
ipaddresses.update({'IDaaS-AD-01': u'10.0.2.20',
 'IDaaS-CAM-01': u'10.0.2.228',
 'IDaaS-D1IM-01': u'10.0.2.10',
 'IDaaS-NAT-01': u'10.0.1.164',
 'IDaaS-Proxy-01': u'10.0.1.81',
 'IDaaS-SQL-02': u'10.0.3.175',
 'IDaaS-WSUS': u'10.0.1.125'})


# Settings for alias
extra_host_conf.setdefault('alias', []).extend(
  [(u'Cloud AD', ['IDaaS-AD-01']),
 (u'Cloud SQL', ['IDaaS-SQL-02']),
 (u'Cloud Proxy', ['IDaaS-Proxy-01']),
 (u'Update Srv', ['IDaaS-WSUS']),
 (u'Cloud Access Manager', ['IDaaS-CAM-01']),
 (u'D1IM Srv', ['IDaaS-D1IM-01'])])

# Settings for parents
extra_host_conf.setdefault('parents', []).extend(
  [('IDaaS-Proxy-01', ['IDaaS-AD-01']),
 ('IDaaS-Proxy-01', ['IDaaS-CAM-01']),
 ('gw-172-31-172-90', ['IDaaS-Proxy-01']),
 ('IDaaS-Proxy-01', ['IDaaS-SQL-02']),
 ('IDaaS-Proxy-01', ['IDaaS-D1IM-01'])])

host_contactgroups.append(
  ( ['all'], [ '/' + FOLDER_PATH + '/' ], ALL_HOSTS ))

# Host attributes (needed for WATO)
host_attributes.update(
{'IDaaS-AD-01': {'alias': u'Cloud AD',
                 'ipaddress': u'10.0.2.20',
                 'parents': ['IDaaS-Proxy-01'],
                 'tag_OS': '1'},
 'IDaaS-CAM-01': {'alias': u'Cloud Access Manager',
                  'ipaddress': u'10.0.2.228',
                  'parents': ['IDaaS-Proxy-01'],
                  'tag_OS': '1'},
 'IDaaS-D1IM-01': {'alias': u'D1IM Srv',
                   'ipaddress': u'10.0.2.10',
                   'parents': ['IDaaS-Proxy-01'],
                   'tag_OS': '1'},
 'IDaaS-NAT-01': {'ipaddress': u'10.0.1.164',
                  'tag_OS': '2',
                  'tag_networking': 'wan'},
 'IDaaS-Proxy-01': {'alias': u'Cloud Proxy',
                    'ipaddress': u'10.0.1.81',
                    'parents': ['gw-172-31-172-90'],
                    'tag_OS': '1'},
 'IDaaS-SQL-02': {'alias': u'Cloud SQL',
                  'ipaddress': u'10.0.3.175',
                  'parents': ['IDaaS-Proxy-01']},
 'IDaaS-WSUS': {'alias': u'Update Srv', 'ipaddress': u'10.0.1.125'}})

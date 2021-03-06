# Written by WATO
# encoding: utf-8

rules += \
[{'actions': [],
  'autodelete': False,
  'count': {'algorithm': 'interval',
            'count': 5,
            'count_ack': False,
            'period': 86400,
            'separate_application': False,
            'separate_host': False,
            'separate_match_groups': False},
  'description': u'testing msg blast from a cmd line',
  'disabled': False,
  'drop': False,
  'id': 'cmdLine_test',
  'match': u'test from cmd line*',
  'set_contact': u'darren.furlotte@openwindows.com.au',
  'sl': 0,
  'state': 2},
 {'actions': [],
  'autodelete': False,
  'description': u'Failed to authenticate to',
  'disabled': False,
  'drop': False,
  'hits': 10,
  'id': 'Defender',
  'match': u'Access-Request',
  'match_host': u'IDAAS-AD-01',
  'set_application': u'Defender',
  'set_contact': u'haydn.cahir@openwindows.com.au',
  'sl': 0,
  'state': 1},
 {'actions': [],
  'autodelete': False,
  'description': u'',
  'disabled': False,
  'drop': False,
  'hits': 10,
  'id': 'dazSA_Test_Rule',
  'match': u'',
  'match_application': u'dazSA',
  'match_ok': u'stop',
  'match_priority': (7, 0),
  'sl': 0,
  'state': -1},
 {'actions': [],
  'autodelete': False,
  'description': u'',
  'disabled': False,
  'drop': False,
  'hits': 5,
  'id': 'Auth_Ack',
  'match': u'Authentication Acknowledged User-Name',
  'set_comment': u'RULE WORKS',
  'sl': 0,
  'state': 1}]

# Written by WATO
# encoding: utf-8

roles.update(
{'admin': {'alias': 'Administrator', 'builtin': True, 'permissions': {}},
 'guest': {'alias': 'Guest user', 'builtin': True, 'permissions': {}},
 'user': {'alias': u'Normal monitoring user',
          'builtin': True,
          'permissions': {'general.see_all': True}}})

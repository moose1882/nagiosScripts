# Written by WATO
# encoding: utf-8


logwatch_rules = [
  ( [('I', 'The endpoint format is invalid', '')], ['/' + FOLDER_PATH + '/+'], ALL_HOSTS, ALL_SERVICES ),
] + logwatch_rules


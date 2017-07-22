# Written by WATO
# encoding: utf-8

all_hosts += [
  "localhost|2|cmk-agent|prod|lan|tcp|wato|/" + FOLDER_PATH + "/",
]

# Explicit IP addresses
ipaddresses.update({'localhost': u'127.0.0.1'})


# Host attributes (needed for WATO)
host_attributes.update(
{'localhost': {'ipaddress': u'127.0.0.1',
               'tag_OS': '2',
               'tag_networking': 'lan'}})

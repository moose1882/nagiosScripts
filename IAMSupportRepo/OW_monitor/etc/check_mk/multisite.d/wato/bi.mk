# Written by WATO
# encoding: utf-8

aggregation_rules["checkmk"] = {
 'aggregation': 'worst',
 'nodes': [('$HOST$', 'Check_MK|Uptime')],
 'params': ['HOST'],
 'title': 'Check_MK'
}

aggregation_rules["networking"] = {
 'aggregation': 'worst',
 'nodes': [('$HOST$', 'NFS|Interface|TCP')],
 'params': ['HOST'],
 'title': 'Networking'
}

aggregation_rules["general"] = {
 'aggregation': 'worst',
 'nodes': [('$HOST$',
            HOST_STATE),
           ('$HOST$', 'Uptime'),
           ('checkmk', ['$HOST$'])],
 'params': ['HOST'],
 'title': 'General State'
}

aggregation_rules["wifi"] = {
 'aggregation': 'worst!1!2',
 'comment': u'',
 'nodes': [(u'AP*',
            HOST_STATE)],
 'params': [],
 'title': u'WiFi'
}

aggregation_rules["host"] = {
 'aggregation': 'worst',
 'nodes': [('general', ['$HOST$']),
           ('performance', ['$HOST$']),
           ('filesystems', ['$HOST$']),
           ('networking', ['$HOST$']),
           ('applications', ['$HOST$']),
           ('logfiles', ['$HOST$']),
           ('hardware', ['$HOST$']),
           ('other', ['$HOST$'])],
 'params': ['HOST'],
 'title': 'Host $HOST$'
}

aggregation_rules["filesystems"] = {
 'aggregation': 'worst',
 'nodes': [('$HOST$', 'Disk|MD'),
           ('multipathing', ['$HOST$']),
           (FOREACH_SERVICE,
            [],
            '$HOST$',
            'fs_(.*)',
            'filesystem',
            ['$HOST$', '$1$'])],
 'params': ['HOST'],
 'title': 'Disk & Filesystems'
}

aggregation_rules["hardware"] = {
 'aggregation': 'worst',
 'nodes': [('$HOST$', 'IPMI|RAID')],
 'params': ['HOST'],
 'title': 'Hardware'
}

aggregation_rules["applications"] = {
 'aggregation': 'worst',
 'nodes': [('$HOST$', 'ASM|ORACLE|proc')],
 'params': ['HOST'],
 'title': 'Applications'
}

aggregation_rules["multipathing"] = {
 'aggregation': 'worst',
 'nodes': [('$HOST$', 'Multipath')],
 'params': ['HOST'],
 'title': 'Multipathing'
}

aggregation_rules["other"] = {
 'aggregation': 'worst',
 'nodes': [('$HOST$',
            REMAINING)],
 'params': ['HOST'],
 'title': 'Other'
}

aggregation_rules["filesystem"] = {
 'aggregation': 'worst',
 'nodes': [('$HOST$', 'fs_$FS$$'),
           ('$HOST$', 'Mount options of $FS$$')],
 'params': ['HOST', 'FS'],
 'title': '$FS$'
}

aggregation_rules["performance"] = {
 'aggregation': 'worst',
 'nodes': [('$HOST$',
            'CPU|Memory|Vmalloc|Kernel|Number of threads')],
 'params': ['HOST'],
 'title': 'Performance'
}

aggregation_rules["logfiles"] = {
 'aggregation': 'worst',
 'nodes': [('$HOST$', 'LOG')],
 'params': ['HOST'],
 'title': 'Logfiles'
}


host_aggregations.append(
(
 'Hosts',
 FOREACH_HOST,
 ['tcp'],
 ALL_HOSTS,
 'host',
 ['$1$']
))
aggregations.append(
(
 'Main', 'wifi', []
))

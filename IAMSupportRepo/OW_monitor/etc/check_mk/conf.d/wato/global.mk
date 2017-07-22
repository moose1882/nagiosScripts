# Written by WATO
# encoding: utf-8

notification_host_body = u'State:   The State has changed from: $LASTHOSTSTATE$ to: $HOSTSTATE$ ($NOTIFICATIONTYPE$)\n\nOutput:   $HOSTOUTPUT$\nPerfdata: $HOSTPERFDATA$\n$LONGHOSTOUTPUT$\n'
inventory_check_do_scan = False
notification_logging = 0
use_inline_snmp = True
win_dhcp_pools_inventorize_empty = True
if_inventory_uses_alias = True
inventory_check_interval = 120
if_inventory_uses_description = True
logwatch_service_output = 'default'
notification_service_subject = u'$HOSTNAME$ Service $NOTIFICATIONTYPE$ - OWA - NOC: $SERVICEDESC$'
notification_service_body = u'Service:  $SERVICEDESC$\nState:    The State has changed from: $LASTSERVICESTATE$ to: $SERVICESTATE$ ($NOTIFICATIONTYPE$)\n\nOutput:   $SERVICEOUTPUT$\nPerfdata: $SERVICEPERFDATA$\n$LONGSERVICEOUTPUT$\n'
notification_host_subject = u'$HOSTNAME$ Host $NOTIFICATIONTYPE$ - OWA - NOC: Host'
if_inventory_porttypes = ['6', '32', '62', '117']

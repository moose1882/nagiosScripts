#!/bin/bash

[ -e /omd/sites/idaas/.profile ] && . /omd/sites/idaas/.profile
[ -e /omd/sites/idaas/.thruk   ] && . /omd/sites/idaas/.thruk

# set omd environment
export CATALYST_CONFIG="/omd/sites/idaas/etc/thruk"

# execute fastcgi server
exec "/omd/sites/idaas/share/thruk/script/thruk_fastcgi.pl";

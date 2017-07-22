<?php
// Created by OMD hook MULTISITE_COOKIE_AUTH
//
$conf['useacl'] = 1;
$conf['authtype'] = 'authmultisite';
$conf['superuser'] = '@admin';
$conf['multisite']['authfile'] = '/omd/sites/idaas/var/check_mk/wato/auth/auth.php';
$conf['multisite']['auth_secret'] = '/omd/sites/idaas/etc/auth.secret';
$conf['multisite']['auth_serials'] = '/omd/sites/idaas/etc/auth.serials';
$conf['multisite']['htpasswd'] = '/omd/sites/idaas/etc/htpasswd';
?>

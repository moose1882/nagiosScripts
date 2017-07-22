<?php
// Created by OMD hook MULTISITE_COOKIE_AUTH
//
// Using the multisite cookie based authentication when no
// REMOTE_USER available.
//
$conf['auth_multisite_enabled']    = TRUE;
$conf['auth_multisite_htpasswd']   = '/omd/sites/idaas/etc/htpasswd';
$conf['auth_multisite_secret']     = '/omd/sites/idaas/etc/auth.secret';
$conf['auth_multisite_serials']    = '/omd/sites/idaas/etc/auth.serials';
$conf['auth_multisite_login_url']  = '/idaas/check_mk/login.py';
?>

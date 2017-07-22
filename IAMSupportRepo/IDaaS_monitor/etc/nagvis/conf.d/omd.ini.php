; <?php return 1; ?>
; -----------------------------------------------------------------
; Don't touch this file. It is under control of OMD. Modifying this
; file might break the update mechanism of OMD.
;
; If you want to customize your NagVis configuration please use the
; etc/nagvis/nagvis.ini.php file.
; -----------------------------------------------------------------

[global]
sesscookiepath="/idaas/nagvis"

[paths]
base="/omd/sites/idaas/share/nagvis/"
local_base="/omd/sites/idaas/local/share/nagvis/"
cfg="/omd/sites/idaas/etc/nagvis/"
mapcfg="/omd/sites/idaas/etc/nagvis/maps/"
geomap="/omd/sites/idaas/etc/nagvis/geomap/"
var="/omd/sites/idaas/tmp/nagvis/"
sharedvar="/omd/sites/idaas/tmp/nagvis/share/"
profiles="/omd/sites/idaas/var/nagvis/profiles/"
htmlbase="/idaas/nagvis"
local_htmlbase="/idaas/nagvis/local"
htmlcgi="/idaas/nagios/cgi-bin"

[defaults]
backend="idaas"

[backend_idaas]
backendtype="mklivestatus"
socket="unix:/omd/sites/idaas/tmp/run/live"

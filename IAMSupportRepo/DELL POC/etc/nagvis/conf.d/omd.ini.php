; <?php return 1; ?>
; -----------------------------------------------------------------
; Don't touch this file. It is under control of OMD. Modifying this
; file might break the update mechanism of OMD.
;
; If you want to customize your NagVis configuration please use the
; etc/nagvis/nagvis.ini.php file.
; -----------------------------------------------------------------

[global]
sesscookiepath="/idaas_mon/nagvis"

[paths]
base="/omd/sites/idaas_mon/share/nagvis/"
local_base="/omd/sites/idaas_mon/local/share/nagvis/"
cfg="/omd/sites/idaas_mon/etc/nagvis/"
mapcfg="/omd/sites/idaas_mon/etc/nagvis/maps/"
geomap="/omd/sites/idaas_mon/etc/nagvis/geomap/"
var="/omd/sites/idaas_mon/tmp/nagvis/"
sharedvar="/omd/sites/idaas_mon/tmp/nagvis/share/"
profiles="/omd/sites/idaas_mon/var/nagvis/profiles/"
htmlbase="/idaas_mon/nagvis"
local_htmlbase="/idaas_mon/nagvis/local"
htmlcgi="/idaas_mon/nagios/cgi-bin"

[defaults]
backend="idaas_mon"

[backend_idaas_mon]
backendtype="mklivestatus"
socket="unix:/omd/sites/idaas_mon/tmp/run/live"

<?php
# This file was automatically generated by the MediaWiki 1.24.1
# installer. If you make manual changes, please keep track in case you
# need to recreate them later.
#
# See includes/DefaultSettings.php for all configurable settings
# and their default values, but don't forget to make changes in _this_
# file, not there.
#
# Further documentation for configuration settings may be found at:
# https://www.mediawiki.org/wiki/Manual:Configuration_settings

# Protect against web entry
if ( !defined( 'MEDIAWIKI' ) ) {
	exit;
}

## Uncomment this to disable output compression
# $wgDisableOutputCompression = true;

$wgSitename = "iamwiki";
$wgMetaNamespace = "Iamwiki";

## The URL base path to the directory containing the wiki;
## defaults for all runtime URL paths are based off of this.
## For more information on customizing the URLs
## (like /w/index.php/Page_title to /wiki/Page_title) please see:
## https://www.mediawiki.org/wiki/Manual:Short_URL
$wgScriptPath = "/w";
$wgScriptExtension = ".php5";

## The protocol and server name to use in fully-qualified URLs
$wgServer = "http://192.168.1.82";

## The relative URL path to the skins directory
$wgStylePath = "$wgScriptPath/skins";

## The relative URL path to the logo.  Make sure you change this from the default,
## or else you'll overwrite your logo when you upgrade!
## $wgLogo = "$wgScriptPath/resources/assets/wiki.png";
$wgLogo = "$wgScriptPath/resources/assets/ow_logo-blue_black_41_0.png";

## UPO means: this is also a user preference option

$wgEnableEmail = true;
$wgEnableUserEmail = true; # UPO

$wgEmergencyContact = "darren.furlotte@openwindows.com.au";
$wgPasswordSender = "darren.furlotte@openwindows.com.au";

$wgEnotifUserTalk = false; # UPO
$wgEnotifWatchlist = false; # UPO
$wgEmailAuthentication = true;

## Database settings
$wgDBtype = "mysql";
$wgDBserver = "localhost";
$wgDBname = "wikidb";
$wgDBuser = "mediawiki";
$wgDBpassword = "0p3nW1nd0w5";

# MySQL specific settings
$wgDBprefix = "ow";

# MySQL table options to use during installation or update
$wgDBTableOptions = "ENGINE=InnoDB, DEFAULT CHARSET=binary";

# Experimental charset support for MySQL 5.0.
$wgDBmysql5 = true;

## Shared memory settings
$wgMainCacheType = CACHE_NONE;
$wgMemCachedServers = array();

## To enable image uploads, make sure the 'images' directory
## is writable, then set this to true:
$wgEnableUploads = true;
$wgUseImageMagick = true;
$wgImageMagickConvertCommand = "/usr/bin/convert";

# InstantCommons allows wiki to use images from http://commons.wikimedia.org
$wgUseInstantCommons = true;

## If you use ImageMagick (or any other shell command) on a
## Linux server, this will need to be set to the name of an
## available UTF-8 locale
$wgShellLocale = "en_US.utf8";

## If you want to use image uploads under safe mode,
## create the directories images/archive, images/thumb and
## images/temp, and make them all writable. Then uncomment
## this, if it's not already uncommented:
#$wgHashedUploadDirectory = false;

## Set $wgCacheDirectory to a writable directory on the web server
## to make your wiki go slightly faster. The directory should not
## be publically accessible from the web.
#$wgCacheDirectory = "$IP/cache";

# Site language code, should be one of the list in ./languages/Names.php
$wgLanguageCode = "en";

$wgSecretKey = "793c08195e54c7ecf0aa5160a71cd635ba036c6c5098afebd169988a99fbd520";

# Site upgrade key. Must be set to a string (default provided) to turn on the
# web installer while LocalSettings.php is in place
$wgUpgradeKey = "396ded63d73ad2f4";

## For attaching licensing metadata to pages, and displaying an
## appropriate copyright notice / icon. GNU Free Documentation
## License and Creative Commons licenses are supported so far.
$wgRightsPage = ""; # Set to the title of a wiki page that describes your license/copyright
$wgRightsUrl = "";
$wgRightsText = "";
$wgRightsIcon = "";

# Path to the GNU diff3 utility. Used for conflict resolution.
$wgDiff3 = "/usr/bin/diff3";

# The following permissions were set based on your choice in the installer
$wgGroupPermissions['*']['edit'] = false;

## Default skin: you can change the default skin. Use the internal symbolic
## names, ie 'vector', 'monobook':
$wgDefaultSkin = "vector";

# Enabled skins.
# The following skins were automatically enabled:
require_once "$IP/skins/CologneBlue/CologneBlue.php";
require_once "$IP/skins/Modern/Modern.php";
require_once "$IP/skins/MonoBook/MonoBook.php";
require_once "$IP/skins/Vector/Vector.php";


# End of automatically generated settings.
# Add more configuration options below.



//The Gadgets extension provides a way for users to pick JavaScript or CSS
//based "gadgets" that other wiki users provide.
  require_once( "$IP/extensions/Gadgets/Gadgets.php" );
  
 // require_once "$IP/extensions/RestrictAccessByCategoryAndGroup/RestrictAccessByCategoryAndGroup.php";
  
//////////////////////////////
// START Lockdown and Access Control Panel
//////////////////////////// 
//Lockdown bit
	require_once "$IP/extensions/Lockdown/Lockdown.php";
$wgGroupPermissions['*']['createaccount'] = false;
$wgGroupPermissions['*']['edit'] = false;
$wgGroupPermissions['*']['read'] = false;
# Allow anonymous user to read the Main Page and login page
$wgWhitelistRead = array( ":Main Page", "Special:Userlogin" );

//
//Access Control bit.
//

require_once("$IP/extensions/UMEduWiki/AccessControlPanel/AccessControlPanel.php");
$wgAccessControlPanelAllowedGroup = 'ACL_admin';
$wgGroupPermissions[$wgAccessControlPanelAllowedGroup]['read']   = true;
$wgGroupPermissions[$wgAccessControlPanelAllowedGroup]['edit']   = true;
//$wgGroupPermissions['Teacher']['*']  = true;

//////////////////////////////
// START Boilerplate 
//////////////////////////// 
$wgMultiBoilerplateDiplaySpecialPage = true;
require_once "$IP/extensions/MultiBoilerplate/MultiBoilerplate.php";
$wgMultiBoilerplateOptions[ "Network Doco" ] = "Template:Network Documentation";
$wgMultiBoilerplateOptions[ "TagCloud‎" ] = "Template:TagCloud‎";

//////////////////////////////
// START Maintenance 
//////////////////////////// 
require_once "$IP/extensions/Maintenance/Maintenance.php";
$wgGroupPermissions['Teacher']['maintenance']  = true;

//////////////////////////////
// START Email Integration 
//////////////////////////// 
$wgSMTP = array(
 'host'     => "mail.openwindows.com.au",
 'IDHost'   => "openwindows.com.au",
 'port'     => 25,
 'auth'     => false,
 'username' => "wiki@openwindows.com.au",
 'password' => "0p3nW1nd0w5"
);

//////////////////////////////
// Tag Cloud
//////////////////////////// 
require_once "$IP/extensions/WikiCategoryTagCloud/WikiCategoryTagCloud.php";

//////////////////////////////
// Job Queue Fix
//////////////////////////// 

//// $wgJobRunRate = 0;
$wgPhpCli = False;
$wgShowExceptionDetails = true;
$wgShowSQLErrors = 1;
//////////////////////////////
// Allowed File Types Upload
//////////////////////////// 
$wgEnableUploads       = true;
$wgAllowExternalImages = true;
$wgVerifyMimeType = false;
$wgStrictFileExtensions = false;
$wgCheckFileExtensions = false;
$wgFileExtensions = array(
    'png', 'gif', 'jpg', 'jpeg', 'jp2', 'webp', 'ppt', 'pdf', 'psd',
    'mp3', 'xls', 'xlsx', 'swf', 'doc','docx', 'odt', 'odc', 'odp',
    'odg', 'mpp', 'ppk', 'key','asc','temp'
    );
//////////////////////////////
// Embed PDF files extension
////////////////////////////
//<pdf>http://some.site.com/with/a/document.pdf</pdf>
//<pdf>Your_uploaded_document.pdf</pdf> 
	require_once("$IP/extensions/EmbedPDF.php");
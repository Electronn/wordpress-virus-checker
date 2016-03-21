#!/usr/bin/perl

use strict;
use warnings;

use wp_core;
use Getopt::Long qw(GetOptions);
my($checkupload,$checkplugin,$checkimages,$help);
my $path = '/';
my $mode = '';
my $lang = '';
GetOptions(
	'path=s' => \$path,
#	'check-core' => \$checkcore,
	'disable-check-upload' => \$checkupload,
	'disable-check-plugin' => \$checkplugin,
	'disable-check-images' => \$checkimages,
	'mode=s' => \$mode,
	'lang=s' => \$lang,
	'help' => \$help,
) ;
#WP_CORE->new('ru');
#WP_CORE->path('/var/www/');
#WP_CORE->check_core('log-expert');
#WP_CORE->check_upload();
#WP_CORE->plugin_check();
if ($help) { 
	print "\nWordPress Checker virus tool. \n\nUsage :\n\n";
	print "--path                 : Shared path to your sites ( For example for /var/www/site1.com and /var/www/site2.com shared path - /var/www ). Default : '/'\n";
	print "--lang                 : Lagnuage of your WordPress copy. ( 'en' or 'ru' )\n";
	print "--mode                 : Checker mode. Use blank for console output only. Use 'log' for simply logging. Use 'log-expert' for logging with diff on all of files.\n"; 
	print "                         Log for 'log' - /tmp/wordpress_checker/core.debug\n";
	print "                         Log for 'log-expert' - /tmp/wordpress_checker/core.log.expert\n";
	print "--disable-check-plugin : Disable plugin dirs and files check\n";
	print "--disable-check-upload : Disable upload dirs check for php files\n";
	print "--disable-check-images : Disable all of images check for EXIF php injection\n\n";
	print "Example : ./wpchecker.pl --path=/var/www --lang=en --mode=log-expert --disable-check-images\n";
	die "\n";
}
if ($lang ne 'ru' && $lang ne 'en') { die "Language not set or set incorrectly ( only en/ru ) \n"; } { WP_CORE->new("$lang"); }
WP_CORE->path("$path");
WP_CORE->check_core("$mode");
if (!$checkupload) { WP_CORE->check_upload(); }
if (!$checkplugin) { WP_CORE->plugin_check(); }
if (!$checkimages) { WP_CORE->check_images(); }
#if ($checkplugin) { $checkplugin = 0; } else { $checkplugin = 1; }
#if ($checkimages) { $checkimages = 0; } else { $checkimages = 1; }
#print "CHECK-UPLOAD - $checkupload\n";
#print "CHECK-PLUGIN - $checkplugin\n";
#print "CHECK-IMAGES - $checkimages\n";
#print "PATH - $path\n";
#print "MODE - $mode\n";
#print "LANG - $lang\n";
#WP_CORE->new('ru');
#WP_CORE->path('/var/www/');
#WP_CORE->check_core('log-expert');
#WP_CORE->check_upload();
#WP_CORE->plugin_check();


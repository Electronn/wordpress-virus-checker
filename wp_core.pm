#!/usr/bin/perl

use strict;
use warnings;

package WP_CORE;
our $pwd = `pwd`;
our $wp_path;
our $for_full_test = 'hello';
our %wp_core_ru;
our %wp_core_en;
our @full_path;
my $wget_check = `which wget | wc -l`;
my $unzip_check = `which unzip | wc -l`;
my $tar_check = `which tar | wc -l`;
my $diff_check = `which diff | wc -l`;
my $identify = `which identify | wc -l`;
chomp($wget_check,$unzip_check,$tar_check,$diff_check,$identify);
if ($wget_check == 0) { die "wget not found\n"; }
if ($unzip_check == 0) { die "unzip not found\n"; }
if ($tar_check == 0) { die "tar not found\n"; }
if ($diff_check == 0) { die "diff not found\n"; }
if ($identify == 0) { die "identify not found\n"; }
sub new {
        my $class = shift;
        my $self = {
	        lang => shift,
        };
	bless $self, $class;
	my $lang = $self->{lang};
	my $wordpress_url;
	if ( ! -d "/tmp/wordpress_checker" ) { system("mkdir /tmp/wordpress_checker /tmp/wordpress_checker/core /tmp/wordpress_checker/plugins"); }
	if ( $lang eq 'ru' ) { 
		system("wget -q 'https://ru.wordpress.org/latest-ru_RU.tar.gz' -O /tmp/wordpress_checker/latest_ru.tar.gz") == 0 or die "Can\'t download last WordPress archive\n";
		if ( ! -d '/tmp/wordpress_checker/core/ru/' ) { system("mkdir -p /tmp/wordpress_checker/core/ru/"); }
		system("tar zxf /tmp/wordpress_checker/latest_ru.tar.gz -C /tmp/wordpress_checker/core/ru/");
		system("find /tmp/wordpress_checker/core/ru/wordpress/* -type f -exec md5sum \{\} \\; > /tmp/wordpress_checker/core/ru/wp_core.md5");
		system("sed -i 's/\\/tmp\\/wordpress_checker\\/core\\/ru\\/wordpress\\///g' /tmp/wordpress_checker/core/ru/wp_core.md5");
		my $wp_core_hashes = `cat /tmp/wordpress_checker/core/ru/wp_core.md5 | awk '{print \$1}'`;
		my $wp_core_files = `cat /tmp/wordpress_checker/core/ru/wp_core.md5 | awk '{print \$2}'`;
		chomp($wp_core_hashes,$wp_core_files);
		my @wp_core_hashes = split(' ',$wp_core_hashes);
		my @wp_core_files = split(' ',$wp_core_files);
		@wp_core_ru{@wp_core_files} = @wp_core_hashes;
	}
	if ( $lang eq 'en' ) { 
		system("wget -q 'https://wordpress.org/latest.tar.gz' -O /tmp/wordpress_checker/latest_en.tar.gz") == 0 or die "Can\'t download last WordPress archive\n";
		if ( ! -d '/tmp/wordpress_checker/core/en/' ) { system("mkdir -p /tmp/wordpress_checker/core/en/"); }
		system("tar zxf /tmp/wordpress_checker/latest_en.tar.gz -C /tmp/wordpress_checker/core/en/");
		system("find /tmp/wordpress_checker/core/en/wordpress/* -type f -exec md5sum \{\} \\; > /tmp/wordpress_checker/core/en/wp_core.md5");
		system("sed -i 's/\\/tmp\\/wordpress_checker\\/core\\/en\\/wordpress\\///g' /tmp/wordpress_checker/core/en/wp_core.md5");
                my $wp_core_hashes = `cat /tmp/wordpress_checker/core/en/wp_core.md5 | awk '{print \$1}'`;
                my $wp_core_files = `cat /tmp/wordpress_checker/core/en/wp_core.md5 | awk '{print \$2}'`;
                chomp($wp_core_hashes,$wp_core_files);
                my @wp_core_hashes = split(' ',$wp_core_hashes);
                my @wp_core_files = split(' ',$wp_core_files);
                @wp_core_ru{@wp_core_files} = @wp_core_hashes;
	}
	return $lang;
}
sub path {
	my $class = shift;
	my $self = {
		path => shift,
	};
	bless $self, $class;
	$wp_path = $self->{path};
	if (!$wp_path) { die "Path not set\n"; }
}
sub check_core {
        my $class = shift;
        my $self = {
                debug => shift,
        };
	my $debug = $self->{debug};
	if (!$debug) { $debug = 0 }
        bless $self, $class;
	my $wp_path_2 = `find $wp_path -name wp-config.php | sed 's/wp-config.php//g'`;
	chomp($wp_path_2);
	my @wp_path = split(' ',$wp_path_2);
	foreach	(@wp_path) { push(@full_path,"$_"); }
	print "Checking Wordpress core files :\n";
	my $for_full;
	foreach my $check (keys %wp_core_ru) {
	        foreach $for_full (@full_path) {
	                my $file_to_check = "$for_full/$check";
	                if ( -f $file_to_check ) {
	                        my $md5sum = `md5sum $file_to_check | awk '{print \$1}'`;
	                        chomp($md5sum);
                	        if ($md5sum ne $wp_core_ru{"$check"}) { 
					print "$file_to_check is changed\n"; 
					if ( $debug eq 'log' ) { system(" echo \"$file_to_check is changed\" >> /tmp/wordpress_checker/core.debug"); }
	                                if ( $debug eq 'log-expert' ) {
	                                        system(" echo \"$file_to_check is changed\" >> /tmp/wordpress_checker/core.debug");
	                                        system(" diff -u /tmp/wordpress_checker/core/ru/wordpress/$check $file_to_check >> /tmp/wordpress_checker/core.log.expert");
	                                }

				}

	                }
	        }
	}
        foreach my $check (keys %wp_core_en) {
                foreach $for_full (@full_path) {
                        my $file_to_check = "$for_full/$check";
                        if ( -f $file_to_check ) {
                                my $md5sum = `md5sum $file_to_check | awk '{print \$1}'`;
                                chomp($md5sum);
                                if ($md5sum ne $wp_core_ru{"$check"}) {
                                        print "$file_to_check is changed\n";
                                        if ( $debug eq 'log' ) { system(" echo \"$file_to_check is changed\" >> /tmp/wordpress_checker/core.debug"); }
                                        if ( $debug eq 'log-expert' ) {
                                                system(" echo \"$file_to_check is changed\" >> /tmp/wordpress_checker/core.debug");
                                                system(" diff -u /tmp/wordpress_checker/core/en/wordpress/$check $file_to_check >> /tmp/wordpress_checker/core.log.expert");
                                        }

				}
                        }
                }
        }
}
sub plugin_check {
	print "Plugin warnings : \n";
	foreach my $plugin_path (@full_path ) {
		my $plugins = `find $plugin_path/wp-content/plugins/* -maxdepth 0 -type d | sed 's/\\// /g' | awk '{print \$(NF)}'`;
		chomp($plugins);
		my @plugins = split(' ',$plugins);
		foreach (@plugins) {
			if ( $_ eq "sabre" ) { next; }
			if ( $_ eq "akismet" ) { next; }
			if (! -d '/tmp/wordpress_checker/plugins') { system("mkdir /tmp/wordpress_checker/plugins"); }
			if ( -d "/tmp/wordpress_checker/plugins/$_" ) { system("rm -rf /tmp/wordpress_checker/plugins/$_"); }
			system("wget -q https://downloads.wordpress.org/plugin/$_.zip -O /tmp/wordpress_checker/plugins/$_.zip");
			system("unzip -q /tmp/wordpress_checker/plugins/$_ -d /tmp/wordpress_checker/plugins/");
			my $files_check = `find $plugin_path/wp-content/plugins/$_/* -type f`;
			my $files_eth = `find /tmp/wordpress_checker/plugins/$_/* -type f`;
			chomp($files_check, $files_eth);
			my @files_check = split(' ',$files_check);
			my @files_eth = split(' ',$files_eth);
			foreach $12 (@files_check) {
		                my $file_to_check = "$12";
        		        $file_to_check =~ s/$plugin_path\/wp-content\/plugins/\/tmp\/wordpress_checker\/plugins/g;
                		if ( ! -f "$file_to_check" ) { print "File $12 not found\n"; next; }
		                if ( -f $12 ) {
	        	                my $eth = `md5sum $file_to_check | awk '{print \$1}'`;
        	        	        my $check_file = `md5sum $12 | awk '{print \$1}'`;
                	        	chomp($eth, $check_file);
					if ( $eth ne $check_file ) { print "File $12 - was been changed\n"; }
	        	        }
        		}
		}
	}
}
sub check_upload {
	print "Upload dir viruses : \n";
	foreach my $upload_path (@full_path ) {
		system("find $upload_path/wp-content/uploads/* -type f -name \"*.php\"");
	}
}	
sub check_images {
	print "Check jpg, jpeg, png for exif php injection :\n";
	foreach my $exif_check (@full_path) {
        	my $files = `find $exif_check -name "*.jpg" -o -name "*.png" -o -name "*.jpeg"`;
		chomp($files);
		my @files = split(' ',$files);
	        foreach (@files) {
			my $check = `identify -format \%\[exif:*\] $_ | grep php | wc -l`;
	      		chomp($check);
		        if ($check ne '0') { print "File possibly virused - $_\n"; }
	        }
	}
}

1;

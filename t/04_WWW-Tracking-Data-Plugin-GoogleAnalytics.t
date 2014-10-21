#!/usr/bin/perl

use strict;
use warnings;

#use Test::More 'no_plan';
use Test::More tests => 4;
use Test::Differences;

use FindBin qw($Bin);
use lib "$Bin/lib";

BEGIN {
	use_ok ( 'WWW::Tracking' ) or exit;
	use_ok ( 'WWW::Tracking::Data::Plugin::GoogleAnalytics' ) or exit;
}

AS_GA_MAKE_TRACKING_REQUEST: {
	my %initial_data = (
		hostname           => 'test.kutej.net',
		request_uri        => '/path/to/there',
		remote_ip          => '109.72.0.72',
		user_agent         => 'Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20100101 Firefox/5.0 Iceweasel/5.0',
		referer            => 'http://jozef.kutej.net/?q=referer',
		browser_language   => 'de-AT',
		java               => 0,
		encoding           => 'UTF-8',
		screen_color_depth => '24',
		screen_resolution  => '1024x768',
		flash_version      => '9.0',
		visitor_id         => '202cb962ac59075b964b07152d234b70',
	);
	my $wt = WWW::Tracking->new(
		'tracker_account' => 'MO-9226801-5',
		'tracker_type'    => 'ga'
	)->from('hash' => \%initial_data);
	is($wt->data->as_ga, 'http://www.google-analytics.com/__utm.gif?&utmac=MO-9226801-5&utmn=115935801&utmcc=__utma%3D999.999.999.999.999.1%3B&utmhn=test.kutej.net&utmp=%2Fpath%2Fto%2Fthere&utmr=http%3A%2F%2Fjozef.kutej.net%2F%3Fq%3Dreferer&utmvid=202cb962ac59075b964b07152d234b70&utmip=109.72.0.72&utmcs=UTF-8&utmul=de-AT&utmje=0&utmsc=24&utmsr=1024x768&utmfl=9.0', 'as_ga()');
	
	eval { $wt->make_tracking_request };
	SKIP: {
		if ($@) {
			diag $@;
			skip 'tracking request failed, no network connection?', 1;
		}
		
		ok(1, 'tracking request passed');
	}
}

package WWW::Tracking::Data::Plugin::GoogleAnalytics;

no warnings 'redefine';

sub _uniq_gif_id { 115935801 };

1;

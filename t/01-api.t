#!perl

use strict;
use warnings;

use Test::More tests => 2;

use WebService::OMDBAPI;

my @methods = qw(new get search);

my %api;
@api{@methods} = (1) x @methods;

can_ok('WebService::OMDBAPI', @methods);

my @extra =
	grep {! $api{$_}}
	grep {$_ !~/\A_/}
	grep {; no strict 'refs'; *{"WebService::OMDBAPI::$_"}{CODE}}
	sort keys %WebService::OMDBAPI::;

ok(! scalar @extra, 'no unexpected methods') or diag "Found: @extra";

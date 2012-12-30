#!perl

use strict;
use warnings;

use Test::More tests => 1;
use Test::MockObject::Extends;
use HTTP::Tiny;

use WebService::OMDBAPI;

my $http = HTTP::Tiny->new;
$http = Test::MockObject::Extends->new($http);
my $omdb = WebService::OMDBAPI->new($http);

$http->set_always('get', { success => 0, reason => 'Not found' });

local $@;
eval { $omdb->search('matrix') };
like($@, qr/^Request failed/, 'request failed');

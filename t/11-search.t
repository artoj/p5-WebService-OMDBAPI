#!perl -T

use strict;
use warnings;

use Test::More tests => 4;
use Test::MockObject::Extends;
use HTTP::Tiny;

use WebService::OMDBAPI;

my $http = HTTP::Tiny->new;
$http = Test::MockObject::Extends->new($http);
my $omdb = WebService::OMDBAPI->new($http);

my @content;

while (<DATA>) {
	push @content, $_;
}

$http->set_always('get', { success => 1, content => $content[0] });
is(scalar @{$omdb->search('foobar')}, 0, 'no results');
is(scalar @{$omdb->search('foobar', 2013)}, 0, 'no results');

$http->set_always('get', { success => 1, content => $content[1] });
is(scalar @{$omdb->search('true grit', 2010)}, 1, 'one result');

$http->set_always('get', { success => 1, content => $content[2] });
is(scalar @{$omdb->search('true grit')}, 5, 'multiple results');

__DATA__
{"Response":"False","Error":"Movie not found!"}
{"Search":[{"Title":"True Grit","Year":"2010","imdbID":"tt1403865"}]}
{"Search":[{"Title":"True Grit","Year":"2010","imdbID":"tt1403866"},{"Title":"True Grit","Year":"1969","imdbID":"tt0065126"},{"Title":"True Grit","Year":"1978","imdbID":"tt0078422"},{"Title":"Old vs. New: True Grit","Year":"2011","imdbID":"tt1915447"},{"Title":"CMT: True Grit","Year":"2006","imdbID":"tt0799861"}]}

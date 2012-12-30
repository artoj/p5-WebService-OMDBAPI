#!perl

use strict;
use warnings;

use Test::More tests => 2;
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

$http->set_always('get', { success => 2, content => $content[0] });
is($omdb->get('tt'), undef, 'invalid id');

$http->set_always('get', { success => 1, content => $content[1] });
isnt($omdb->get('tt1403865'), undef, 'valid id');

__DATA__
{"Response":"False","Error":"Incorrect IMDb ID"}
{"Title":"True Grit","Year":"2010","Rated":"PG-13","Released":"22 Dec 2010","Runtime":"1 h 50 min","Genre":"Adventure, Drama, Western","Director":"Ethan Coen, Joel Coen","Writer":"Joel Coen, Ethan Coen","Actors":"Jeff Bridges, Matt Damon, Hailee Steinfeld, Josh Brolin","Plot":"A tough U.S. Marshal helps a stubborn young woman track down her father's murderer.","Poster":"http://ia.media-imdb.com/images/M/MV5BMjIxNjAzODQ0N15BMl5BanBnXkFtZTcwODY2MjMyNA@@._V1_SX300.jpg","imdbRating":"7.8","imdbVotes":"142,737","imdbID":"tt1403865","Response":"True"}

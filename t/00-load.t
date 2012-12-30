#!perl

use strict;
use warnings;

use Test::More tests => 1;

require_ok('WebService::OMDBAPI');

note("WebService::OMDBAPI $WebService::OMDBAPI::VERSION, Perl $], $^X" );

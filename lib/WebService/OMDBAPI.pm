package WebService::OMDBAPI;

use strict;
use warnings;

use JSON ();
use HTTP::Tiny;
use Carp ();

our $VERSION = 0.01;
our $OMDBAPI_URL = 'http://www.omdbapi.com/?';

sub new {
	my ($class, $http) = @_;
	$http //= HTTP::Tiny->new;

	my $self = { http => $http };

	return bless $self, $class;
}

sub _send_request {
	my ($self, $params) = @_;

	my $response =  $self->{http}->get($OMDBAPI_URL .
	    $self->{http}->www_form_urlencode($params));

	Carp::croak 'Request failed: ' . $response->{reason}
	    unless $response->{success};

	return JSON->new->utf8->decode($response->{content});
}

sub search {
	my ($self, $title, $year) = @_;
	my $params = { s => $title };
	$params->{y} = $year if $year;

	my $json = $self->_send_request($params);
	return exists $json->{Error} ? [] : $json->{Search};
}

sub get {
	my ($self, $imdbid, %params) = @_;
	$params{i} = $imdbid;

	my $json = $self->_send_request(\%params);
	return exists $json->{Error} ? undef : $json;
}

1;

__END__

=pod

=head1 NAME

WebService::OMDBAPI - Interface to the OMDBAPI

=head1 VERSION

version 0.01

=head1 SYNOPSIS

    use WebService::OMDBAPI;

    my $omdbapi = WebService::OMDBAPI->new;

    for (@{$omdbapi->search('true grit')}) {
        my $info = $omdbapi->get($_->{imdbID});

        print $info->{Title} . ' ' . $info->{imdbRating} . "\n";
    }

=head1 DESCRIPTION

This module is an interface to the OMDBAPI service which provides information
about movies. Movies can be searched by title and further information can be
retrieved by using the Internet Movie Database (IMDb) identifier.

=head1 METHODS

=head2 new

    $omdbapi = WebService::OMDBAPI->new;
    $omdbapi = WebService::OMDBAPI->new($http);

Constructs and returns an OMDBAPI object. Optionally an a
L<HTTP::Tiny|HTTP::Tiny> object can be passed to the constructor to be used as
a HTTP client.

=head2 search

    $results = $omdbapi->search($title);
    $results = $omdbapi->search($title, $year);

Search a movie with the given title and optionally the given year.

The C<search> method returns an arrayref of hashref containing the results.
Each hashref has the following keys: Title, Year and imdbID.

If no search results can found an empty arrayref is returned.

=head2 get

    $info = $omdbapi->get($imdbid);
    $info = $omdbapi->get($imdbid, %options);

Retrieve movie information with the given IMDb identifier.

The C<get> method returns a hashref containing the movie information. The
hashref has the following keys: Title, Year, Rated, Released, Runtime, Genre,
Director, Writer, Actors, Plot, Poster, imdbRating, imdbVotes and imdbID.

Valid options include:

=over 4

=item *

C<plot>

Retrieve C<full> or C<short> plot text. The default is C<short>.

=item *

C<tomatoes>

Retrieve Rotten Tomatoes data. If C<true> the hashref will have the following
additional keys: tomatoMeter, tomatoImage, tomatoRating, tomatoReviews,
tomatoFresh, tomatoRottern, tomatoConsensus, tomatoUserMeter, tomatoUserRating
and tomatoUserReviews.

The default is C<false>.

=back

If no information can be found with the given IMDb identifier an undef is
returned.

=head1 AUTHOR

Arto Jonsson <artoj@iki.fi>

=head1 COPYRIGHT & LICENSE

Copyright (c) 2012-2013 Arto Jonsson

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

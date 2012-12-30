use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'WebService::OMDBAPI',
    license             => 'perl',
    dist_author         => q{Arto Jonsson <artoj@iki.fi>},
    dist_version_from   => 'lib/WebService/OMDBAPI.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
        'Test::MockObject::Extends' => 0,
    },
    requires => {
        'Carp'       => 0,
        'JSON'       => 0,
        'HTTP::Tiny' => 0.014,
    },
    add_to_cleanup     => [ 'WebService-OMDBAPI-*' ],
    create_makefile_pl => 'traditional',
    create_readme      => 1,
);

$builder->create_build_script();

use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Path::Iterator::Rule::RT',
    license             => 'Artistic_2_0',
    dist_author         => q{Robert Blackwell <robert@robertblackwell.com>},
    dist_version_from   => 'lib/Path/Iterator/Rule/RT.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
	RT::Client::REST => 0.45,
    },
    add_to_cleanup     => [ 'Path-Iterator-Rule-RT-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();

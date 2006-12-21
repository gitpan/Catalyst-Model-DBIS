use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Catalyst::Model::DBIS',
    AUTHOR              => 'Naoki Tomita <tomi@e8y.net>',
    VERSION_FROM        => 'lib/Catalyst/Model/DBIS.pm',
    ABSTRACT_FROM       => 'lib/Catalyst/Model/DBIS.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Catalyst'              => '5.00',
        'DBIx::Simple'          => 0,
        'SQL::Abstract::Limit'  => 0,
        'Test::More'            => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Catalyst-Model-DBIS-*' },
);

use inc::Module::Install;

name 'Catalyst-Model-DBIS';
all_from 'lib/Catalyst/Model/DBIS.pm';

requires 'Catalyst';
requires 'DBIx::Simple';
requires 'SQL::Abstract::Limit';

build_requires 'Test::More';

auto_include;

WriteAll;

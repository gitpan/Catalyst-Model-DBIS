#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Catalyst::Model::DBIS' );
}

diag( "Testing Catalyst::Model::DBIS $Catalyst::Model::DBIS::VERSION, Perl $], $^X" );

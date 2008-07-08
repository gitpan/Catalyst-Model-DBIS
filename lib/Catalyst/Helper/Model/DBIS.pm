package Catalyst::Helper::Model::DBIS;
use strict;
use warnings;

=head1 NAME

Catalyst::Helper::Model::DBIS - Helper for DBIS Models

=head1 SYNOPSIS

    % ./script/myapp_create.pl model DBIS DBIS dsn user password

=head1 DESCRIPTION

Helper for the DBIS Models.

=cut

sub mk_compclass {
    my ( $self, $helper, $dsn, $user, $pass ) = @_;
    $helper->{dsn}  = $dsn  || '';
    $helper->{user} = $user || '';
    $helper->{pass} = $pass || '';
    my $file = $helper->{file};
    $helper->render_file( 'compclass', $file );
}

=head1 AUTHOR

Naoki Tomita E<lt>tomita@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Catalyst::Model::DBIS>

=cut

1;

__DATA__

__compclass__
package [% class %];

use strict;
use base 'Catalyst::Model::DBIS';

__PACKAGE__->config(
    connect_info => [
        '[% dsn %]',
        '[% user %]',
        '[% pass %]',
        {
            RaiseError => 1,
        },
    ],
);

=head1 NAME

[% class %] - Catalyst DBIS Model

=head1 SYNOPSIS

See L<[% app %]>

=head1 DESCRIPTION

L<DBIx::Simple> Model Class.

=head1 AUTHOR

[% author %]

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

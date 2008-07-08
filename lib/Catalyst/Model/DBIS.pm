package Catalyst::Model::DBIS;
use strict;
use warnings;
use base 'Catalyst::Model';
use NEXT;
use DBIx::Simple;
use SQL::Abstract::Limit;

our $VERSION = '0.02';

sub new {
    my $self = shift->NEXT::new(@_);
    my @info = @{ $self->{connect_info} || [] };
    
    $self->{dbis} = DBIx::Simple->connect(@info)
             or die DBIx::Simple->error;
    
    $self->{dbis}->abstract = SQL::Abstract::Limit->new(
        limit_dialect => $self->{dbis}->dbh,
    );

    # DBIC's "on_connect_do" emulation
    if (ref $info[-1] eq 'HASH') {
        for my $query (@{ $info[-1]{on_connect_do} || [] }) {
            $self->{dbis}->query($query) or die $self->{dbis}->error;
        }
    }
    
    return $self;
}

sub dbh   { shift->{dbis}->dbh }
sub error { shift->{dbis}->error }

for my $func (qw(
    begin begin_work commit rollback func last_insert_id
    query select insert update delete
    )) {
    
    no strict 'refs'; ## no critic
    
    *$func = sub {
        my $self = shift;
        $self->{dbis}->$func(@_) or die $self->{dbis}->error;
    };
}

sub DESTROY {
    eval { shift->{dbis}->disconnect };
}

1;
__END__

=head1 NAME

Catalyst::Model::DBIS - DBIx::Simple model class

=head1 SYNOPSIS

  $c->model('DBIS')->insert('test_log_db', {
      user_agent      => $c->req->user_agent,
      insert_datetime => ['NOW()'],
  });
  
  $c->stash->{users} = $c->model('DBIS')->select(
      'tickets', '*', {
          status => $c->req->param('status') || 0,
      },
  )->hashes;
  
  $c->model('DBIS')->query('SELECT 1 + 1')->into( $c->stash->{answer} );

=head1 DESCRIPTION

B<Note:> This is a super simple L<DBIx::Simple> model. If you're interested this,
L<Catalyst::Model::DBIC::Schema> help you I promise.
B<Catalyst::Model::DBIS will be deprecated>.

=head1 CREATE APP MODEL CLASS

Using helper...(see L<Catalyst::Helper::Model::DBIS>)

  % ./script/myapp_create.pl model DBIS DBIS dsn user password

Or manually create in lib/MyApp/Model/DBIS.pm
    
  package MyApp::Model::DBIS;
  use strict;
  use base 'Catalyst::Model::DBIS';
  
  __PACKAGE__->config(
      connect_info => [
          'dbi:mysql:myapp_db',
          'myapp_user',
          'myapp_pass',
          { RaiseError => 1 },
          { on_connect_do => [ 'set names utf8' ] },
      ],
  );
  
  1;

=head1 CONFIG

In lib/MyApp/Model/DBIS.pm as above, or in myapp.yaml file like this.

  Model::DBIS:
  connect_info:
      - dbi:SQLite:dbname=myapp.db

=over 4

=item connect_info

List of arguments to C<< DBI->connect() >>. See L<DBI> for more description.

=over 4

=item on_connect_do

This module emulates L<DBIx::Class>'s C<on_connect_do> feature. C<connect_info>
can take a hash at the end.

=back

=back

=head1 AUTHOR

Naoki Tomita E<lt>tomita@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Catalyst::Helper::Model::DBIS>, L<DBIx::Simple>

=cut

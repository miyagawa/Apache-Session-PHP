package Apache::Session::PHP;

use strict;
use vars qw($VERSION);
$VERSION = 0.01;

use Apache::Session;
use base qw(Apache::Session);

use Apache::Session::Generate::MD5;
use Apache::Session::Serialize::PHP;
use Apache::Session::Lock::Null;
use Apache::Session::Store::PHP;

sub populate {
    my $self = shift;

    $self->{object_store} = Apache::Session::Store::PHP->new($self);
    $self->{lock_manager} = Apache::Session::Lock::Null->new($self);
    $self->{generate}     = \&Apache::Session::Generate::MD5::generate;
    $self->{validate}     = \&Apache::Session::Generate::MD5::validate;
    $self->{serialize}    = \&Apache::Session::Serialize::PHP::serialize;
    $self->{unserialize}  = \&Apache::Session::Serialize::PHP::unserialize;
    return $self;
}

1;
__END__

=head1 NAME

Apache::Session::PHP - glues Apache::Session with PHP::Session

=head1 SYNOPSIS

  use Apache::Session::PHP;

  tie %session, 'Apache::Session::PHP', $sid, {
      SavePath => '/var/sessions',
  };

=head1 DESCRIPTION

Apache::Session::PHP is an adapter of Apache::Session for
PHP::Session. It uses following combination of straregies:

=over 4

=item Generate: MD5

PHP4 session also uses 32bit session-id, generated by MD5 of random
string. So MD5 (default) generation would fit.

=item Serialize: PHP

uses PHP::Session::Serializer::PHP.

=item Lock: Null

PHP4 uses exclusive flock for session locking. In Apache::Session, we
use Null for locking and Store module executes flock on opening the
session file.

=item Store: PHP

similarto File store, but file naming scheme is slightly different.

=back

=head1 NOTE

PHP does NOT have distinction between hash and array. Thus
PHP::Session restores PHP I<array> as Perl I<hash>.

  Perl  =>  PHP  => Perl
  array    array    hash

Thus if you store array in sessions, what'll come back is hash.

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Apache::Session>, L<PHP::Session>

=cut
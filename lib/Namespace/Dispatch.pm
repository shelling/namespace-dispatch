package Namespace::Dispatch;
our $VERSION = '0.01';

use 5.010;
use UNIVERSAL::filename;

sub import {
    my $caller = caller;

    *{$caller . "::" . "has_leaf"} = sub {
        my ($class, $name) = @_;
        my @leaves = @{$class->leaves} if $class->can("leaves");
        if ( $name ~~ @leaves ) {
            return $class . "::" . ucfirst($name);
        } else {
            return 0;
        }
    };

    *{$caller . "::" . "dispatch"} = sub {

        my $class   = shift;
        my $next    = shift;
        my $handler = $class->has_leaf($next);

        if ($handler) {

            eval qq{ use $handler };
            die $@ if $@;

            if ($handler->can("dispatch")) {
                return $handler->dispatch(@_);
            } else {
                die "$handler is not set up yet (forgot to use Namespace::Dispatch?)";
            }

        } else {
            return $class;
        }

    };

    *{$caller . '::' . 'leaves'} = sub {
        my $class = shift;
        my $file = $class->filename;
        $file =~ s{.pm$}{}g;
        use File::Basename;
        my @submodules = map { $_ = lc basename($_) } glob "$file/*.pm";
        map { $_ =~ s{\.pm$}{}; } @submodules;
        [@submodules];
    };

}


1;
__END__

=head1 NAME

Namespace::Dispatch -

=head1 SYNOPSIS

  use Namespace::Dispatch;

=head1 DESCRIPTION

Namespace::Dispatch is

=head1 AUTHOR

shelling E<lt>navyblueshellingford@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

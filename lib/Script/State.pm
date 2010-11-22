package Script::State;
use strict;
use warnings;
use PadWalker qw(var_name);
use Data::Dumper;

our $VERSION = '0.01';

our $DATAFILE;
our $SCRIPT_DATA;
our $VAR_REF;

sub script_state {
    my $name = var_name 1, \$_[0] or do {
        require Carp;
        Carp::croak('Invalid variable passed');
    };
    $VAR_REF->{$name} = \$_[0];

    if (exists $SCRIPT_DATA->{$name}) {
        $_[0] = $SCRIPT_DATA->{$name};
    } elsif ($#_ >= 1) {
        $_[0] = $_[1];
    }
}

sub import {
    my ($class, %args) = @_;

    $DATAFILE = delete $args{-datafile} || do {
        require File::Spec;
        my ($vol, $dirs, $file) = File::Spec->splitpath($0);
        File::Spec->catpath($vol, $dirs, ".$file.pl");
    };

    $SCRIPT_DATA = -r $DATAFILE ? do $DATAFILE : {};

    my $pkg = caller;
    no strict 'refs';
    *{ "$pkg\::script_state" } = \&script_state;
}

END {
    if ($DATAFILE && $VAR_REF) {
        open my $fh, '>', $DATAFILE or do {
            warn "Could not open $DATAFILE: $!";
            return;
        };

        my $vars = { map { $_ => ${ $VAR_REF->{$_} } } keys %$VAR_REF };
        print $fh Data::Dumper->new([ $vars ])->Terse(1)->Indent(1)->Dump;
        close $fh;
    }
}

1;

__END__

=head1 NAME

Script::State - Keep script local variables

=head1 SYNOPSIS

  use Script::State;

  script_state my $count = 0;

  say $count++;

=head1 DESCRIPTION

Script::State stores local variables to file after script execution.

=head1 AUTHOR

motemen E<lt>motemen {at} gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

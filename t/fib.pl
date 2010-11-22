use strict;
use Script::State;

script_state my $x = 1;
script_state my $y = 1;

print $x;

($x, $y) = ($y, $x + $y);

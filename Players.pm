package Players;
use strict;
use warnings;

sub new_player{
	return {object=>$_[0], input_sub=>0};
}

1;

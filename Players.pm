package Players;
use strict;
use warnings;

sub new_player{
	return {object=>$_[0], input_sub=>0};
}

sub step_player{
	my $player = $_[0];
	$player->{"input_sub"}->($player->{"object"});
}

1;

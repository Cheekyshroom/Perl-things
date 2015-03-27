package Players;
use strict;
use warnings;

sub new_player{
	return {object=>$_[0], input_sub=>$_[1]};
}

sub input_player{
	my $player = $_[0];
	my $game = $_[1];
	$player->{"input_sub"}->($player->{"object"}, $game);
}

1;

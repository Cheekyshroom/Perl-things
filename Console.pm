package Console;
use strict;
use warnings;
use Curses;
use Consts;
use Data::Dumper;

sub start_display{
	initscr;
	noecho;
	curs_set 0;
}

sub end_display{
	endwin;
}

sub refresh_display{
	refresh;
}

sub move_cursor{
	move(@_);
}

sub draw_char{
	addch(@_);
}

sub draw_string{
	printw(@_);
}

sub get_char{
	getchar;
}

sub clear_display{
	erase;
}

my $messages = [];
sub message{
	unshift($messages, $_[0]);
}
sub draw_messages{
	my $amount = $_[0];
	for (my $i = 0; $i < $amount; $i++){
		move_cursor(1+Consts::MAP_DISPLAY_HEIGHT+$i, 0);
		last if !$messages->[$i];
		draw_string($messages->[$i]);
	}
}

sub pluralize_string{
	my $str = $_[0];
	my $amount = $_[1];
	return sprintf($str, ($amount == 1 ? "" : "s"));
}

sub draw_turn{
	my $game = $_[0];
	move_cursor(Consts::MAP_DISPLAY_HEIGHT, 0);
	draw_string("on turn ".$game->{"turn"});
}

sub status_line{
	return sprintf("%d health | on turn %d", @_);
}

sub print_stats{
	my $player = $_[0];
	my $game = $_[1];
	if (!$player){
		draw_turn($game);
	} else {
		move_cursor(Consts::MAP_DISPLAY_HEIGHT, 0);
		draw_string(status_line($player->{"object"}->{"health"}, $game->{"turn"}));
	}
}

1;

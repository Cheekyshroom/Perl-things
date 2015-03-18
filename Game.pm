use strict;
use warnings;
package Game;
use Console;
use Objects;
use Consts;
use Names;

sub display_game{
	my $game = $_[0];
	Console::clear_display();
	Map::draw_map($game->{"map"});
	Objects::draw_objects($game->{"objects"});
	Console::move_cursor(${@{$objects}[0]}{"y"}, ${@{$objects}[0]}{"x"});
}

sub run_game{
	my @objects = @{$_[0]};
	Console::start_display();
	while (1){
		display_game(\@objects);
		last if move_with_input(Console::get_char(), $objects[0]);
	}
	Console::end_display();
}

sub new_game{
	return {objects=>[], map=>[[]], object_creator=>sub{}, map_creator=>sub{}, turn=>0};
}

sub step_game{
	
}

1;

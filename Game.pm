use strict;
use warnings;
package Game;
use Consts;
use Console;
use Objects;
use Map;
use Names;

sub display_game{
	my $game = $_[0];
	Console::clear_display();
	Map::draw_map($game->{"map"});
	Objects::draw_objects($game->{"objects"});
}

my $char_inputs = {
	l=>sub{
		$_[0]->{"objects"}->[0]->{"x"}++;
	},
	k=>sub{
		$_[0]->{"objects"}->[0]->{"y"}--;
	},
	j=>sub{
		$_[0]->{"objects"}->[0]->{"y"}++;
	},
	h=>sub{
		$_[0]->{"objects"}->[0]->{"x"}--;
	},
	q=>sub{
		$_[0]->{"continue"} = 0;
	},
};

sub handle_input{
	my $game = $_[0];
	my $input = $_[1];
	my $decision = $char_inputs->{$input};
	if ($decision){
		$decision->($game);
	}
}

sub run_game{
	my $game = $_[0];
	Console::start_display();
	while (1){
		display_game($game);
		handle_input($game, Console::get_char());
		last unless step_game($game);
	}
	Console::end_display();
}

my @object_symbols = ("a".."z", "A".."Z");
sub new_obj{
	return
		{x=>int(rand(20)),
		 y=>int(rand(20)),
		 name=>Names::random_name(3),
		 symbol=>$object_symbols[int(rand($#object_symbols+1))],
		 id=>$_[0]};
}

my $map_width = 40;
my $map_height = 12;
sub new_game{
	my $game = {
		continue=>1,
		turn=>0,
		objects=>[],
		map=>[[]],
		object_creator=>sub{
			my $id = 0; #create a new closure, there's probably a better way...
			return sub{
				return [map {
					Objects::new_object(int(rand($map_width)), int(rand($map_height)), 
						Names::random_name(3), 0.0, 0.0, $id++);
					} (1..$_[0])];
			};
		}->(),
		map_creator=>sub{
			return Map::new_map($_[0], $_[1], sub{
				my $m = $_[0];
				for (my $x = 0; $x < $_[1]; $x++){
					for (my $y = 0; $y < $_[2]; $y++){
						$m->[$x][$y]->{"symbol"} = '.';
					}
				}
				return $m;
			});
		},
	};
	$game->{"map"} = $game->{"map_creator"}->($map_width, $map_height);
	$game->{"objects"} = $game->{"object_creator"}->(5);
	return $game;
}

sub step_game{
	my $game = $_[0];
	return $game->{"continue"};
}

1;

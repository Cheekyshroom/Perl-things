use strict;
use warnings;
use diagnostics;
package Game;
use Consts;
use Console;
use Objects;
use Players;
use Map;
use Names;
use Data::Dumper;

my $map_width = Consts::MAP_DISPLAY_WIDTH;
my $map_height = Consts::MAP_DISPLAY_HEIGHT;

sub display_game{
	my $game = $_[0];
	Console::clear_display();

	Map::draw_map($game->{"map"});
	Objects::draw_objects($game->{"objects"});

	Console::draw_messages(3);
	Console::print_stats($game->{"players"}[0], $game);

	Console::move_cursor(50, 0);

	Console::refresh_display();
}

my $char_inputs = {
	l=>[sub{
			Objects::walk($_[0], [1,0]);
	    }, 1],
	k=>[sub{
			Objects::walk($_[0], [0,-1]);
		 }, 1],
	j=>[sub{
			Objects::walk($_[0], [0,1]);
	    }, 1],
	h=>[sub{
			Objects::walk($_[0], [-1,0]);
		 }, 1],
	'.'=>[sub{
  			return;
			}, 0],
	q=>[sub{
			$_[1]->{"continue"} = 0;
		 }, 0],
};

sub handle_input{
	my $game = $_[0];
	my $object = $_[1];
	my $input = $_[2];
	my $decision = $char_inputs->{$input};
	if ($decision){
		$decision->($object, $game);
	}
}

sub object_creator_from_string{
	return sub{
			my @object_symbols = ("a".."z", "A".."Z");
			my $id = 0; #create a new closure, there's probably a better way...
			return sub{
				return [map {
					Objects::new_object(int(rand($map_width)), int(rand($map_height)),
						$object_symbols[int(rand($#object_symbols+1))], 
						Names::random_name(3), $id++, int(rand(17))+3,
						int(rand(2))+1, [0,0], 1, 'X');
					} (1..$_[0])];
			};
		}->() if $_[0] eq "random";
}

sub map_creator_from_string{
	return sub{
			return Map::new_map($_[0], $_[1], sub{
				my @tiles = (
					"cobblestone", "cobblestone", "pusher",
					"cobblestone", "spikes", "cobblestone",
					"cobblestone", "cobblestone", "cobblestone",
					"ice", "ice", "ice",
					"ice", "ice", "ice",
					"ice", "ice", "ice",
					"ice", "ice", "ice",
				);
				my $m = $_[0];
				for (my $x = 0; $x < $_[1]; $x++){
					for (my $y = 0; $y < $_[2]; $y++){
						if ($y == $_[2]-1 || $x == $_[1]-1 || $x == 0 || $y == 0){
							$m->[$x][$y] = Map::new_tile_helper("cobblestone");
						} else {
							$m->[$x][$y] = Map::new_tile_helper(@tiles[int(rand($#tiles+1))]);
						}
					}
				}
				return $m;
			});
		} if $_[0] eq "random";
}

sub player_input_handler_from_string{
	return sub{
			my $player = $_[0];
			my $game = $_[1];
			my $input = Console::get_char;
			handle_input($game, $player, $input);
		} if $_[0] eq "console";
}

sub new_game{
	my $object_mode = $_[0];
	my $map_mode = $_[1];
	my $player_input_mode = $_[2];
	my $game = {
		continue=>1,
		turn=>0,
		objects=>[],
		map=>[[]],
		players=>[],
		object_creator=>object_creator_from_string($object_mode),
		map_creator=>map_creator_from_string($map_mode),
		player_input_sub=>player_input_handler_from_string($player_input_mode),
	};
	$game->{"map"} = $game->{"map_creator"}->($map_width, $map_height);
	add_object($game);
	add_object($game);
	add_player($game);
	return $game;
}

sub add_object{
	my $game = $_[0];
	push($game->{"objects"}, @{$game->{"object_creator"}->(1)});
	return $game->{"objects"}->[$#{$game->{"objects"}}];
}

sub add_player{
	my $game = $_[0];
	push($game->{"players"}, Players::new_player(add_object($game), $game->{"player_input_sub"}));
}

sub step_game{
	my $game = $_[0];
	for my $player (@{$game->{"players"}}){
		Players::input_player($player, $game);
	}
	for my $object (@{$game->{"objects"}}){
		Objects::step_object($object, $game->{"map"});
	}
	for my $player (@{$game->{"players"}}){
		$player->{"ap"} = $player->{"max_ap"};
	}
	$game->{"turn"}++;
	return $game->{"continue"};
}

sub run_game{
	my $game = $_[0];
	Console::start_display();
	while (1){
		display_game($game);
		last unless step_game($game);
	}
	Console::end_display();
}

1;

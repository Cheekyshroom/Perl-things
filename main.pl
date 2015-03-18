#!/usr/bin/env perl
use strict;
use warnings;
use Console;
use Objects;
use Consts;
use Names;
use Game;
#use Data::Dumper;

sub display_game{
	my $objects = $_[0];
	Console::clear_display();
	Objects::draw_objects($objects);
	Console::move_cursor(${@{$objects}[0]}{"y"}, ${@{$objects}[0]}{"x"});
}

sub move_with_input{
	my $ch = $_[0];
	my $oref = $_[1];
	if ($ch eq "l") { $oref->{"x"}++; }
	elsif ($ch eq "h") { $oref->{"x"}--; }
	elsif ($ch eq "k") { $oref->{"y"}--; } 
	elsif ($ch eq "j") { $oref->{"y"}++; }
	else { return 1; }
	return 0;
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

my @object_symbols = ("a".."z", "A".."Z");
sub new_obj{
	return
		{x=>int(rand(20)),
		 y=>int(rand(20)),
		 name=>Names::random_name(),
		 symbol=>$object_symbols[int(rand($#object_symbols+1))],
		 id=>$_[0]};
}

my $ocreator = Objects::new_object_creator();
my @objects = map { $_ = $ocreator->(\&new_obj, []) } (1..10);

run_game Game::new_game();

#!/usr/bin/env perl
use strict;
use warnings;
use Game;
#use Data::Dumper;

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

#!/usr/bin/env perl
use strict; 
use warnings;
use Game;
use Data::Dumper;

my $run = shift(@ARGV);
my $game = Game::new_game("random", "random", "console");
print Dumper($game) if !$run;
Game::run_game($game) if $run;

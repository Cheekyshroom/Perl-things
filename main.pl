#!/usr/bin/env perl
use strict; 
use warnings;
use Game;
#use Data::Dumper;

my $game = Game::new_game();
Game::run_game($game);

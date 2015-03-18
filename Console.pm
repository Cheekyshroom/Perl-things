package Console;
use strict;
use warnings;
use Curses;

sub start_display{
	initscr;
	noecho;
	curs_set 0;
}

sub end_display{
	endwin;
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

1;

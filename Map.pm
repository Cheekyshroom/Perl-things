use strict;
use warnings;
package Map;
use Console;
use Consts;
use Objects;

sub new_2d_array{
	my @out;
	for (my $y = 0; $y < $_[0]; $y++){
		my @temp;
		for (my $x = 0; $x < $_[1]; $x++){
			$temp[$x] = $_[2]->();
		}
		$out[$y] = \@temp;
	}
	return \@out;
}

sub new_tile{
	return {symbol=>$_[0], on_step=>$_[1], on_update=>$_[2], friction_coefficient=>$_[3], passable=>$_[4]};
}

my $tile_types = {
	cobblestone=>
		new_tile('.', 0, 0, Consts::FRICTION_DEFAULT, 1),
	wall=>
		new_tile('#', 0, 0, 0.0, 0),
	sand=>
		new_tile('~', 0, 0, 0.05, 1),
	mud=>
		new_tile('%', 0, 0, 0.01, 1),
	spikes=>
		new_tile('^',
			sub{
				my $object = $_[0];
				my $map = $_[1];
				Objects::damage($object, 3);
				Console::message($object->{"name"}." got damaged for 3 damage");
			},
			0,
			Consts::FRICTION_DEFAULT, 1),
};

sub new_tile_from_type{
	return new_tile('.', 0, 0, 0.3) if $_[0] eq "tile";
	return new_tile('.', 0, 0, 0.3) if $_[0] eq "wall";
	return new_tile('.', 0, 0, 0.3) if $_[0] eq "sand";
	return new_tile('.', 0, 0, 0.3) if $_[0] eq "mud";
	return new_tile('.', 0, 0, 0.3) if $_[0] eq "spikes";
}

sub new_tile_helper{
	return new_tile_from_type($_[0]) if $#_ == 0;
	return new_tile($_[0], $_[1], $_[2], $_[3], $_[4]) if $#_ == 5;
	return new_tile(' ', 0, 0, 0.3, 1);
}

sub draw_map{
	my $map = $_[0];
	my $width = $map->{"width"};
	my $height = $map->{"height"};
	my $data = $map->{"data"};
	for (my $y = 0; $y < $height; $y++){
		for (my $x = 0; $x < $width; $x++){
			Console::draw_char($y, $x, $data->[$x][$y]->{"symbol"});
		}
	}
}

#takes a width and height, and returns a map creator
sub new_map{
	my $width = $_[0];
	my $height = $_[1];
	my $modifier = $_[2];
	my $data = new_2d_array($width, $height, sub{return new_tile_helper();});
	return {width=>$width, height=>$height, data=>$modifier->($data, $width, $height)};
}

1;

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

sub new_tile($;$;$;$){
	return {symbol=>$_[0], on_step=>$_[1], on_update=>$_[2], passable=>$_[3]};
}

my $tile_types = {
	cobblestone=>sub{
		return new_tile('.', 0, 0, 1);
	},
	wall=>sub{
		return new_tile('#', 0, 0, 0);
	},
	sand=>sub{
		return new_tile('~', 0, 0, 1);
	},
	mud=>sub{
		return new_tile('%', 0, 0, 1);
	},
	spikes=>sub{
		return new_tile('^',
			sub{
				my $object = $_[0];
				my $map = $_[1];
				Objects::damage($object, 3);
				Console::message($object->{"name"}." got damaged for 3 damage!");
			}, 0, 1);
	},
	default=>sub{
		return new_tile(' ', 0, 0, 1);
	},
	pusher=>sub{
		return new_tile('?',
			sub{
				my $object = $_[0];
				my $map = $_[1];
				Objects::walk($object, [int(rand(3))-1, int(rand(3))-1]);
				Objects::move($object);
			}, 0, 1);
	},
};

sub new_tile_from_type{
	my $tile = $tile_types->{$_[0]};
	if ($tile){
		return $tile->();
	}
	return $tile_types->{"default"}->();
}

sub new_tile_helper{
	return new_tile_from_type($_[0]) if $#_ == 0;
	return new_tile($_[0], $_[1], $_[2], $_[3]) if $#_ == 4;
	return new_tile(' ', 0, 0, 1);
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

sub activate_on_step{
	my $object = $_[0];
	my $map = $_[1];
	my $onstep = $map->{"data"}->[$object->{"x"}][$object->{"y"}]->{"on_step"};
	if ($onstep){
		$onstep->($object, $map);
	}
}

1;

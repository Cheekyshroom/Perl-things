use strict;
use warnings;
package Map;
use Console;

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
	return {symbol=>' ', on_step=>0, on_update=>0} if $#_ == -1;
	return {symbol=>$_[0], on_step=>0, on_update=>0} if $#_ == 0;
	return {symbol=>$_[0], on_step=>$_[1], on_update=>0} if $#_ == 1;
	return {symbol=>$_[0], on_step=>$_[1], on_update=>$_[2]} if $#_ == 2;
	return {symbol=>$_[0], on_step=>$_[1], on_update=>$_[2], other_data=>{@_[3..$#_]}};
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
	my $data = new_2d_array($width, $height, sub{return new_tile();});
	return {width=>$width, height=>$height, data=>$modifier->($data, $width, $height, @_[3..$#_])};
}

1;

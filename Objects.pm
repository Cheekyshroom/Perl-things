package Objects;
use strict;
use warnings;
use Console;
use Storable;
use Consts;
use Map;

#may as well just store the ref in an object but maybe this copies it?
sub draw_object{
	my $object = $_[0];
	if ($object->{"alive"}){
		Console::draw_char($object->{"y"}, $object->{"x"}, $object->{"symbol"});
	} else {
		Console::draw_char($object->{"y"}, $object->{"x"}, $object->{"dead_symbol"});
	}
}

sub draw_objects{
	my @objects = @{$_[0]};
	foreach my $object (@objects){
		draw_object $object;
	}
}

sub new_object($;$;$;$;$;$;$;$;$;$){
	return {
		x=>$_[0],
		y=>$_[1],
		symbol=>$_[2],	
		name=>$_[3],
		id=>$_[4],
		health=>$_[5],
		ap=>$_[6], 
		max_ap=>$_[6], 
		direction=>$_[7], 
		alive=>$_[8], 
		dead_symbol=>$_[9],
	};
}

sub move{
	my $object = $_[0];
	my $map = $_[1];
	if ($object->{"alive"}){
		my $nx = $object->{"x"}+$object->{"direction"}->[0];
		my $ny = $object->{"y"}+$object->{"direction"}->[1];
		if (Map::in_bounds($map, $nx, $ny)){
			$object->{"x"} = $nx;
			$object->{"y"} = $ny;
		}
	}
}

sub walk{
	if ($_[0]->{"alive"}){
		$_[0]->{"direction"} = $_[1];
	}
}

sub damage{
	$_[0]->{"health"}-=$_[1];
}

sub step_object{
	my $object = $_[0];
	#objects can come back to life!
	$object->{"alive"} = $object->{"health"} <= 0 ? 0 : 1;
	if ($object->{"alive"}){
		my $map = $_[1];
		move($object, $map);
		Map::activate_on_step($object, $map);
		#walk($object, [0,0]);
	}
}

1;

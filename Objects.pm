package Objects;
use strict;
use warnings;
use Console;
use Storable;
use Consts;

#may as well just store the ref in an object but maybe this copies it?
sub draw_object{
	my $oref = $_[0];
	Console::draw_char($oref->{"y"}, $oref->{"x"}, $oref->{"symbol"});
}

sub draw_objects{
	my @objects = @{$_[0]};
	foreach my $oref (@objects){
		draw_object $oref;
	}
}

#store an object in a file
sub store_object{
	return "";
}

#load an object from a file, preserves everything about it
sub load_object{
	return "";
}

#parse an object from a string
#(not for loading objects, merely creating them from alternate input)
sub parse_object{
	return {direction=>Consts::PI, speed=>0.0, x=>0, y=>0, symbol=>".", name=>$_[0], id=>$_[1]};
}

sub new_object{
	return {x=>$_[0], y=>$_[1], symbol=>$_[2], name=>$_[3], direction=>$_[4], speed=>$_[5], id=>$_[6], health=>$_[7]};
}

sub move_object{
	my $object = $_[0];
	$object->{"x"}+=$object->{"speed"}*cos($object->{"direction"});
	$object->{"y"}+=$object->{"speed"}*sin($object->{"direction"});
}

sub update_speed{
	my $object = $_[0];
	my $map = $_[1];
	$object->{"speed"} *= $map->{"data"}->[$object->{"x"}][$object->{"y"}]->{"friction_coefficient"};
	$object->{"speed"} = 0.0 if abs($object->{"speed"})<Consts::FRICTION_THRESHOLD;
}

sub walk{
	$_[0]->{"direction"} = $_[1];
	$_[0]->{"speed"}+=$_[2];
}

sub step_object{
	my $object = $_[0];
	my $map = $_[1];
	move_object($object, $map);
	update_speed($object, $map);
}

1;

package Objects;
use strict;
use warnings;
use Console;
use Storable;
use Consts;
use Map;

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

sub new_object($;$;$;$;$;$;$;$){
	return {x=>$_[0], y=>$_[1], symbol=>$_[2], name=>$_[3], id=>$_[4], health=>$_[5], ap=>$_[6], max_ap=>$_[6], direction=>$_[7]};
}

sub move{
	my $object = $_[0];
	$object->{"x"}+=$object->{"direction"}->[0];
	$object->{"y"}+=$object->{"direction"}->[1];
}

sub walk{
	$_[0]->{"direction"} = $_[1];
}

sub damage{
	$_[0]->{"health"}-=$_[1];
}

sub step_object{
	my $object = $_[0];
	my $map = $_[1];
	move($object, $map);
	Map::activate_on_step($object, $map);
}

1;

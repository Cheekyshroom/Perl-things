#Random name generator using markov chains
package Names;
use strict;
use warnings;
use Data::Dumper;

my $digrams = ["al","an","ar","as","at","ea","ed","en","er","es","ha","he","hi","in","is","it","le","me","nd","ne","ng","nt","on","or","ou","re","se","st","te","th","ti","to","ve","wa","th","he","an","er","in","re","nd","ou","en","on","ed","to","it","ha","at","ve","or","as","hi","ar","te","es","ng","is","st","le","al","ti","se","wa","ea","me","nt","ne"];
my $trigrams = ["all","and","are","but","ent","era","ere","eve","for","had","hat","hen","her","hin","his","ing","ion","ith","not","ome","oul","our","sho","ted","ter","tha","the","thi","tio","uld","ver","was","wit","you","the","and","ing","her","you","ver","was","hat","not","for","thi","tha","his","ent","ith","ion","ere","wit","all","eve","oul","uld","tio","ter","hen","had","sho","our","hin","era","are","ted","ome","but"];
my $ngrams = [@{$digrams}, @{$trigrams}];

sub endwithvowelp{
	return $_[0] =~ /^[a-z]*[aeiou]$/;
}
sub endwithconsp{
	return !endwithvowelp(@_);
}
sub startwithvowelp{
	return $_[0] =~ /^[aeiou][a-z]*$/;
}
sub startwithconsp{
	return !startwithvowelp(@_);
}
my $ends_in_a_vowel = [map { endwithvowelp($_) ? $_ : (); } @{$ngrams}];
my $ends_in_a_consonant = [map { endwithconsp($_) ? $_ : (); } @{$ngrams}];
my $starts_with_a_consonant = [map { startwithconsp($_) ? $_ : (); } @{$ngrams}];
my $starts_with_a_vowel = [map { startwithvowelp($_) ? $_ : (); } @{$ngrams}];

#our starting syllables are a copy of the unpadded array of tri and di grams
my @starting_syllables = @{$ngrams};

#add each element of the most common di and trigrams to our syllable list
my $syllables = {};
foreach my $element (@{$ngrams}){
	#here we have to decide which grams to link this one back to
	$syllables->{$element} = endwithvowelp($element) ? $starts_with_a_consonant : $starts_with_a_vowel;
}

#pad our gram_array with a chance to finish
for (my $c = 0; $c < 20; $c++){
	push($ngrams, 0);
	push($ends_in_a_consonant, 0);
	push($ends_in_a_vowel, 0);
	push($starts_with_a_consonant, 0);
	push($starts_with_a_vowel, 0);
}

#sub load_from_file{
#	open(my $in, "<", $_[0]) or die("Couldn't load syllables from " . $_[0]);
#	
#	close $in;
#}

sub next_syllable{
	my $possibilities = $syllables->{$_[0]};
	return $possibilities->[int(rand($#{$possibilities}+1))];
}

sub random_name_from_syllable{
	my $out = "";
	my $syllable = $_[0];
	do{
		$out .= $syllable;
		$syllable = next_syllable($syllable);
	}while($syllable);
	return $out;
}

sub random_name{
	return random_name_from_syllable($starting_syllables[int(rand($#starting_syllables+1))]);
}

1;

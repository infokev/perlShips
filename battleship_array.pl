#!/usr/bin/perl
use strict;

# define a constant for later conveniance
use constant size => 10;
# create an empty grid
my @oceanEmpty=(
#        1 2 3 4 5 6 7 8 9 10
        [0,0,0,0,0,0,0,0,0,0], # 1
        [0,0,0,0,0,0,0,0,0,0], # 2
        [0,0,0,0,0,0,0,0,0,0], # 3
        [0,0,0,0,0,0,0,0,0,0], # 4
        [0,0,0,0,0,0,0,0,0,0], # 5
        [0,0,0,0,0,0,0,0,0,0], # 6
        [0,0,0,0,0,0,0,0,0,0], # 7
        [0,0,0,0,0,0,0,0,0,0], # 8
        [0,0,0,0,0,0,0,0,0,0], # 9
        [0,0,0,0,0,0,0,0,0,0], # 10
       );
# copy empty grid to each player       
my @oceanPlayer=@oceanEmpty;
my @oceanComputer=@oceanEmpty;
# testing purposes, place a destroyer
# note this is [row][column] positioning
$oceanPlayer[1][2]="d";
$oceanPlayer[5][5]="c";
$oceanPlayer[9][9]="b";

# testing purposes, display the player's ocean
foreach (my $x=0;$x<=size;$x++) {
  foreach (my $y=0;$y<=size;$y++) {
    print $oceanPlayer[$x][$y];
  }
  # after each line, CR
  print "\n";
}
# demonstrate ability to test values in the ocean,
if ($oceanPlayer[1][2] eq "d") {
  print "Destroyer";
}
else {
  print "not Destroyer (Empty)";
}

if ($oceanPlayer[7][5] eq "c") {
  print "Carrier";
}
else {
  print "not carrier (Empty)";
}
if ($oceanPlayer[3][5] eq "d") {
  print "Battleship";
}
else {
  print "not Battleship (Empty)";
}
print "\n";
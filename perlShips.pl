#!/usr/bin/perl
use strict;
# Purpose: demonstrate basics of creating a game loop in
#       a graphics program using SDL, plus text box locations.
#       Program creates an App., creates a text rectangle then put mouse
#       locations in that text rectangle in response to mouse clicks;
#       Reports mouse and keyboard events to CLI. 'x' or 'Q' to quit.
# Date:   2013
# Author:

my ($carrier, $battleship, $destroyer, $frigate, $submerine);
my ($getboard, $player);

use SDL; #needed to get all constants
use SDL::Video;
use SDLx::App;
use SDL::Surface;
use SDL::Rect;
use SDL::Image;
use SDL::Event;
use SDL::Mouse;
# Now use text modules
use SDLx::Text;


my ($gui, $background1, $background, $background_rect, $event, $exiting, $text_box);
# First create a new App
$gui = SDLx::App->new(
    title  => "perlShips",
    width  => 1024, # use same width as background image
    height => 768, # use same height as background image
    depth  => 32,
    exit_on_quit => 1 # Enable 'X' button
);
# Add event handler for quit (covered also by 'q' of 'x' from keyboard)
$gui->add_event_handler( \&quit_event );
# Load an image for the background
# If the program is run without an available image the error
#  "Can't call method "w" on an undefined value at ThisFile.pl line XX."
# will be received.
$background = SDL::Image::load('graphics/grid4.png');
# Create a rectangle for the background image
$background_rect = SDL::Rect->new(0,0,
    $background->w,
    $background->h,
);


$background1 = SDL::Image::load('graphics/double.png');
$background_rect = SDL::Rect->new(0,0,
    $background->w,
    $background->h,
);

# Add in a text box/location; we'll put text in it later
$text_box = SDLx::Text->new(size=>'24', # font can also be specified
                            color=>[255,0,0], # [R,G,B]
                            x =>200,
                            y=> 575);

# Create a new event structure variable
$event = SDL::Event->new();
# Draw the background
SDL::Video::blit_surface($background, $background_rect, $gui, $background_rect );
# Update the window
SDL::Video::update_rects($gui, $background_rect);



$exiting = 0;
# Start a game loop
while ( !$exiting ) {
  $gui->update;
  # Update the queue to recent events
  SDL::Events::pump_events();
  # process all available events
  while (SDL::Events::poll_event($event)) {
    # check by Event type      
    if ($event->type == SDL_QUIT) {
      &quit_event(); 
    }
    elsif ($event->type == SDL_KEYUP) {
        &key_event($event);
    }
    elsif ($event->type == SDL_MOUSEBUTTONDOWN) {
      &mouse_event($event);
    }
  }
  SDL::Video::update_rects($gui);
  # slow things down if required
  $gui->delay(100);
} # game loop

getPlayerPositions();
setupComputer();

while (NOT ending) {

  getPlayerMove();
  testHits();
  #checkgameend
  makeComputerMove();
  #checkgameend
}



sub quit_event {
	exit;
}



sub key_event {
  # printed output from here is going to the CLI
  print "Key is: ";
  my $key_name = SDL::Events::get_key_name( $event->key_sym );  
  print "[$key_name]\n";
  if (($key_name eq "q") || ($key_name eq "Q") ) {
    $exiting = 1;
  }
  if (($key_name eq "x") || ($key_name eq "X") ) {
    $exiting = 1;
  }
}


    


sub mouse_event {
  # printed output from here is going to the CLI
  print "Player: ";
  my ($mouse_mask,$mouse_x,$mouse_y)  = @{SDL::Events::get_mouse_state()};
  print "[$mouse_x, $mouse_y]\n";
  # re-blit the  background - try running this program with the next line commented out
  SDL::Video::blit_surface($background, $background_rect, $gui, $background_rect );
  # Put some text in the previously prepared text box
  #$text_box->write_to($gui,"Player Location: ($mouse_x, $mouse_y)");

}




sub initVars {


}



# you starts the game and bring up the board
sub showBoard {

# this brings up the battlefield where the ships will be placed it is a 10 by 10 grid with a background image infront
#$getboard = 'battleship_array.pl' 'battleship_imagebackground';

}



# the ai places his ships
sub aiPlaceShips {

# the AI ships
my $aiships= $carrier, $battleship, $destroyer, $frigate, $submerine;

# this places the aiships 5 ships in random places
$aiships=int (rand (10));

}



# the player places his ships
sub playerPlaceShips {

# the players ships
my $playerships= $carrier, $battleship, $destroyer, $frigate, $submerine;

# an input box that asks the player where he wants to put his ships
$playerships = <STDIN>;
chomp $playerships

}



# the sub gets the places move
sub getPlayerMove {

  # get the players move.
  #$text_box->write_to($gui,"Player Location: ()");
}



# the sub gets the computer move
sub makeComputerMove {


# make the computer fire one shot
#do 

# until the computer has used his 1 shot.
# until


}



# this sub gets the players move and see if or the ai has hit anything if the have hit something or missed this sub will display it.
sub textHits {

# announce if the player and AI have either hit a ship or have missed.


}



sub winner {

# if the player or ai loses all his ships then the person who still has atleasts 1 health point left wins


}




# [Start Screen 

# Player Vs Computer or Human

# Place your ships or choose random locations
# 5 ships per Char Max total in a game is 10 (1 carrier 5 spaces 1 battleship 4 spaces 1 Destroyer 3 spaces 1 2 Cruisers 3 spaces) 
# Randomiser places your ships at random co-ordinates] 

# Type Start to begin the game
# Popup Screen, Background, Grid 10/10,
#link grid with background

# Enter Cordinates to attack
# [Y Co] [X Co]

# You Missed, You cant fire at that location again

# You Hit a Ship, You cant fire at that location again

# You sunk a ships

# Your ship was sunk

# You have Sunk all enemy ships, You Win

# All your ships have been destroyed, You Lost

# Wanna play again type start

# New Game

# define a constant for later conveniance

# define a constant for later conveniance



use constant size => 10;
# create an empty grid
my @oceanEmpty=(
#        A B C D E F G H I J
        [0,0,0,0,0,0,0,0,0,0], # 0
        [0,0,0,0,0,0,0,0,0,0], # 1
        [0,0,0,0,0,0,0,0,0,0], # 2
        [0,0,0,0,0,0,0,0,0,0], # 3
        [0,0,0,0,0,0,0,0,0,0], # 4
        [0,0,0,0,0,0,0,0,0,0], # 5
        [0,0,0,0,0,0,0,0,0,0], # 6
        [0,0,0,0,0,0,0,0,0,0], # 7
        [0,0,0,0,0,0,0,0,0,0], # 8
        [0,0,0,0,0,0,0,0,0,0], # 9
       );
# copy empty grid to each player       
my @oceanPlayer=@oceanEmpty;
my @oceanComputer=@oceanEmpty;
# testing purposes, place a destroyer
# note this is [row][column] positioning
$oceanPlayer[1][2]="d";
$oceanPlayer[5][5]="c";
$oceanPlayer[9][9]="b";
$oceanPlayer[6][6]="f";
$oceanPlayer[7][8]="s";



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
print "\n";



if ($oceanPlayer[4][5] eq "c") {
  print "Carrier";
}
else {
  print "not carrier (Empty)";
}
print "\n";



if ($oceanPlayer[9][9] eq "b") {
  print "Battleship";
}
else {
  print "not Battleship (Empty)";
}
print "\n";




if ($oceanPlayer[4][6] eq "f") {
  print "Frigate";
}
else {
  print "not Frigate (Empty)";
}
print "\n";




if ($oceanPlayer[7][8] eq "s") {
  print "Submerine";
}
else {
  print "not Submarine (Empty)";
}
print "\n";

##############################################################################################################################################################

sub getPlayerMove {
  $text_box->write_to($gui,"Where will I put the battleship?");
}

sub setupComputer {

}
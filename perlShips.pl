#!/usr/bin/perl
use strict;
# Purpose: demonstrate basics of creating a game loop in
#       a graphics program using SDL, plus text box locations.
#       Program creates an App., creates a text rectangle then put mouse
#       locations in that text rectangle in response to mouse clicks;
#       Reports mouse and keyboard events to CLI. 'x' or 'Q' to quit.
# Date:   2013
# Author:

my ($carrier, $battleship, $destroyer, $frigate, $submarine);
my ($getboard, $player);

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

#use constant => ;
use constant screenWidth => 660;
use constant screenHeight => 494;
use constant textPromptX => 15;
use constant textPromptY => 415;
use constant rectPromptBoxX => 11;
use constant rectPromptBoxY => 408;
my $lineHeight=20;

use constant verbFire => "fire"; 
use constant verbQuit => "quit";

my ($gui, $event, $exiting );
# First create a new App
$gui = SDLx::App->new(
    title  => "perlShips",
    width  => screenWidth, # use same width as background image
    height => screenHeight, # use same height as background image
    depth  => 32,
    exit_on_quit => 1 # Enable 'X' button
);
# Add event handler for quit (covered also by 'q' of 'x' from keyboard)
$gui->add_event_handler( \&quit_event );
# Load an image for the background
# If the program is run without an available image the error
#  "Can't call method "w" on an undefined value at ThisFile.pl line XX."
# will be received.
my ($background, $rectBackground);
$background = SDL::Image::load('graphics/bg_ocean_moon_actual.png');
# Create a rectangle for the background image
$rectBackground = SDL::Rect->new(0,0,
    $background->w,
    $background->h,
);
SDL::Video::blit_surface($background, $rectBackground, $gui, $rectBackground );

my ($promptBox, $rectPromptBox, @textPrompt, $rectPromptBoxMaster);
$promptBox = SDL::Image::load('graphics/promptBox_moon.png');
$rectPromptBoxMaster=SDL::Rect->new(0,0, $promptBox->w,$promptBox->h);
# Create a rectangle for the background image
$rectPromptBox = SDL::Rect->new(rectPromptBoxX, rectPromptBoxY,
    $promptBox->w,
    $promptBox->h,
);
SDL::Video::blit_surface($promptBox, $rectPromptBoxMaster, $gui, $rectPromptBox );
# Add in text box/locations; we'll put text in it later:
# 3 lines
$textPrompt[0] = SDLx::Text->new(size=>'18', # font can also be specified
                            color=>[255,255,255], # [R,G,B]
                            x => textPromptX,
                            y => textPromptY);
$textPrompt[1] = SDLx::Text->new(size=>'18', # font can also be specified
                            color=>[255,255,255], # [R,G,B]
                            x => textPromptX,
                            y => textPromptY+$lineHeight);
$textPrompt[2] = SDLx::Text->new(size=>'18', # font can also be specified
                            color=>[255,255,255], # [R,G,B]
                            x => textPromptX,
                            y => textPromptY+($lineHeight*2));

# Create a new event structure variable
$event = SDL::Event->new();
# Draw the background

# Update the window
SDL::Video::update_rects($gui, $rectBackground, $rectPromptBox);

setPlayerPositions();
setComputerPositions();

$exiting = 0;
# Start a game loop
while ( !$exiting ) {
  $gui->update;
  getPlayerMove();
  testHits();
  getComputerMove();
  testHits();
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

#while (NOT ending) {

  getPlayerMove();
  testHits();
  #checkgameend
  makeComputerMove();
  #checkgameend
#}

sub quit_event {
	exit;
}

sub key_event {
  # printed output from here is going to the CLI
  print "Key is: ";
  my $keyName = SDL::Events::get_key_name( $event->key_sym );  
  print "[$keyName]\n";
  if (($keyName eq "q") || ($keyName eq "Q") ) {
  #  $exiting = 1;
  }
  if (($keyName eq "x") || ($keyName eq "X") ) {
    $exiting = 1;
  }
}

sub mouse_event {
  # printed output from here is going to the CLI
  print "Player: ";
  my ($mouse_mask,$mouse_x,$mouse_y)  = @{SDL::Events::get_mouse_state()};
  print "[$mouse_x, $mouse_y]\n";
  # re-blit the  background - try running this program with the next line commented out
  SDL::Video::blit_surface($background, $rectBackground, $gui, $rectBackground );
  # Put some text in the previously prepared text box
  #$textPrompt->write_to($gui,"Player Location: ($mouse_x, $mouse_y)");

}

sub initVars {
}


# the ai places his ships
sub aiPlaceShips {
  # the AI ships
  my $aiships= $carrier, $battleship, $destroyer, $frigate, $submarine;
  # this places the aiships 5 ships in random places
  $aiships=int (rand (10));

}



# the player places his ships
sub playerPlaceShips {

# the players ships
my $playerships= $carrier, $battleship, $destroyer, $frigate, $submarine;


}



# the sub gets the places move
sub getPlayerMove {

  # get the players move.
  #$textPrompt->write_to($gui,"Player Location: ()");
}



# the sub gets the computer move
sub makeComputerMove {


# make the computer fire one shot
#do 

# until the computer has used his 1 shot.
# until


}



# this sub gets the players move and see if or the ai has hit anything if the have hit something or missed this sub will display it.
sub testHits {

# announce if the player and AI have either hit a ship or have missed.


}



sub winner {

# if the player or ai loses all his ships then the person who still has atleasts 1 health point left wins


}

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
#if ($oceanPlayer[1][2] eq "d") {


##############################################################################################################################################################

sub getPlayerMove {
  promptClear();
  prompt(0, "Your move:");
  my $cmd=getCommand();
  # make command lowercase
  $cmd=lc $cmd;
  showBoard();
  prompt(1, "Got: $cmd");
  processCommand($cmd);
}

sub getComputerMove {

}

sub promptClear {
  # clear prompt area
  SDL::Video::blit_surface($promptBox, $rectPromptBoxMaster, $gui, $rectPromptBox );
  SDL::Video::update_rects($gui, $rectPromptBox);
}

sub prompt {
  # print into prompt area
  my $line=shift;
  my $msg=shift;
  if (length ($msg) > 0) {
    $textPrompt[$line]->write_to($gui, $msg);
    SDL::Video::update_rects($gui, $rectPromptBox);
  }
}

sub getPlayerPositions {
  prompt(0, "Your move:");
  my $pos=getCommand();
  showBoard();
  prompt(1, "Got: $pos");
  print "Got $pos";
}

sub getCommand {
  # get one command line from player
  my $command;
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
        my $keyName = SDL::Events::get_key_name( $event->key_sym );
        if ($keyName ne 'return') {
          translateKey(\$keyName);
          $command .= $keyName;
          &key_event($event);
        }
        else {
          return $command;
        }
      }
      elsif ($event->type == SDL_MOUSEBUTTONDOWN) {
        &mouse_event($event);
      }
    }
    SDL::Video::update_rects($gui);
  } # game loop

}

sub translateKey {
 my $key=shift;
 # use $$ to reference variabubble outside
 if ($$key eq 'space') {
   $$key=' ';
 }
}

sub showBoard {
# this brings up the battlefield where the ships will be placed it is a 10 by 10 grid with a background image infront
#$getboard = 'battleship_array.pl' 'battleship_imagebackground';
  foreach (my $x=0;$x<=size;$x++) {
    foreach (my $y=0;$y<=size;$y++) {
      print $oceanPlayer[$x][$y];
    }
    # after each line, CR
    print "\n";
  }
}

sub setPlayerPositions {

}

sub setComputerPositions {

}

sub processCommand {
  my $commandString=shift; # get what's passed in
  my @command=split "\s", $commandString; # split by whitespace into words
  my $verb=$command[0];
  if ($verb eq verbFire) {
    unshift @command; # get rid of verb now it's identified
    commandFire(@command);
  }
  elsif ($verb eq verbQuit) {
    $exiting=1;
  }
  else {
    prompt(2, "Unknown command ($verb) - press any key to continue");
    $gui->pause();
  }
}

sub commandFire {

}
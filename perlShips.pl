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
use constant screenWidth => 802;
use constant screenHeight => 600;
use constant textPromptX => 50;
use constant textPromptY => 480;
use constant rectPromptBoxX => 44;
use constant rectPromptBoxY => 477;
my $lineHeight=20;

use constant tableTopLeftX => 42; 
use constant tableTopLeftY => 123;
use constant cellWidth => 32;
use constant cellHeight => 32;
use constant secondTableOffset => 320;

use constant verbFire => "fire"; 
use constant verbQuit => "quit";
use constant verbHelp => "help";

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
$background = SDL::Image::load('graphics/Battleship_Main_Image.png');
# Create a rectangle for the background image
$rectBackground = SDL::Rect->new(0,0,
    $background->w,
    $background->h,
);
SDL::Video::blit_surface($background, $rectBackground, $gui, $rectBackground );

my ($promptBox, $rectPromptBox, @textPrompt, $rectPromptBoxMaster);
$promptBox = SDL::Image::load('graphics/promptBox_moon2.png');
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
                            color=>[255,171,0], # [R,G,B]
                            x => textPromptX,
                            y => textPromptY);
$textPrompt[1] = SDLx::Text->new(size=>'18', # font can also be specified
                            color=>[255,171,0], # [R,G,B]
                            x => textPromptX,
                            y => textPromptY+$lineHeight);
$textPrompt[2] = SDLx::Text->new(size=>'18', # font can also be specified
                            color=>[255,100,0], # [R,G,B]
                            x => textPromptX,
                            y => textPromptY+($lineHeight*2));

my ($imageHit, $rectImageHit, $rectImageHitMaster);
$imageHit = SDL::Image::load('graphics/hit_2.png');
$rectImageHitMaster=SDL::Rect->new(0,0, $imageHit->w,$imageHit->h);


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
  showBoard();
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

# this sub gets the players move and see if or the ai has hit anything if the have hit something or missed this sub will display it.
sub testHits {
# announce if the player and AI have either hit a ship or have missed.

}

sub winner {

# if the player or ai loses all his ships then the person who still has atleasts 1 health point left wins

}

# testing purposes, place a destroyer
# note this is [row][column] positioning
#$oceanPlayer[1][2]="d";

# demonstrate ability to test values in the ocean,
#if ($oceanPlayer[1][2] eq "d") {

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
  my ($cols, $rows);
  foreach ($cols=0;$cols<size;$cols++) {
    foreach ($rows=0;$rows<size;$rows++) {
      #print $oceanPlayer[$cols][$rows];
      my $x = tableTopLeftX + ($rows * cellWidth);
      my $y = tableTopLeftY + ($cols * cellHeight);
      drawHit($x, $y);
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
  my @command=split '\s', $commandString; # split by whitespace into words
  my $verb=$command[0];
  if ($verb eq verbFire) {
    shift @command; # get rid of verb now it's identified
    commandFire(@command);
  }
  elsif ($verb eq verbQuit) {
    $exiting=1;
  }
  elsif ($verb eq verbHelp) {
    prompt(2, "Sorry. Help not implemented yet.");
    pause();

  }
  else {
    prompt(2, "Unknown command ($verb)");
    pause();
  }
}

sub commandFire {
  my @command=shift;
  my $target=shift @command; # get grid target 
  my ($gridLetter, $gridNumber) = split '', $target; # split into characters
  if ( (($gridLetter ge 'a') && ($gridLetter le 'j'))  # is letter in ok range
     && (($gridNumber >= 0) && ($gridLetter <= 9)) ) { # is number in ok range
    print "[$gridLetter][$gridNumber]\n";
  }
  else {
    prompt (2, "Unknown grid reference");
    pause();
  }
}

sub pause {
  my $time=shift;
  if ($time > 0) {
    sleep ($time);
  }
  else {
    sleep (1);
  }
}
sub drawHit {
  my ($x, $y) = @_;
  #my $y = shift;
  my $rectImageHit = SDL::Rect->new( $x, $y, $imageHit->w, $imageHit->h );
  SDL::Video::blit_surface($imageHit, $rectImageHitMaster, $gui, $rectImageHit );
  SDL::Video::update_rects($gui, $rectImageHit);
}



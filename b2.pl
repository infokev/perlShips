#!/usr/bin/perl


#
#   Battleship.pl 
#   only one hit sinks a ship
#   run from command prompt at C:\Users>perl battleship.pl enter
#   From www.perlmonks.com
#
##use v5.006;
##use strict;
##use warnings;


&startup();

#******************************************************************************
#*******************************STARTUP FUNCTION*******************************
#******************************************************************************

sub main::startup () {

 local $main::startup::name = "";
 print "\n\nPlease enter your name: ";
 chomp($main::startup::name = <STDIN>);
 &main::call;
}

#*******************************************************************************
#******************************MAIN CALL FUNCTION*******************************
#*******************************************************************************

sub main::call () {
 srand;
 local @main::com_ships::com_all_ships = ();
 local @main::com_ships::com_carrier = ();
 local @main::com_ships::com_battleship = ();
 local @main::com_ships::com_destroyer = ();
 local @main::com_ships::com_submarine = ();
 local @main::com_ships::com_patrol = ();
 local @main::user_ships::user_all_ships = ();
 local @main::user_ships::user_carrier = ();
 local @main::user_ships::user_battleship = ();
 local @main::user_ships::user_destroyer = ();
 local @main::user_ships::user_submarine = ();
 local @main::user_ships::user_patrol = ();
 local @main::com_ships::com_board = (
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   );

 local @main::user_ships::user_board = (
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0],
   );

 local @main::letters::letters = ("A" .. "J");
 local $main::game_play::whos_first = '';
 local $main::game_play::mode = '';
 local @main::game_play::com_shots_check;
 local @main::game_play::user_shots_check;
 local $main::com_ships::hits = '';
 local $main::user_ships::hits = '';
 &generate_ship_pos::start();
 &get_user_ship_pos::start();
 &game_play::start();
}

#*******************************************************************************
#***************************SECONDARY CALL FUNCTIONS****************************
#*******************************************************************************


sub generate_ship_pos::start () {
 &generate_ship_pos::carrier();
 &generate_ship_pos::battleship();
 &generate_ship_pos::destroyer();
 &generate_ship_pos::submarine();
 &generate_ship_pos::patrol();
 &generate_ship_pos::correctional(@main::com_ships::com_all_ships);
}

sub get_user_ship_pos::start () {
 &get_user_ship_pos::carrier();
 &get_user_ship_pos::battleship();
 &get_user_ship_pos::destroyer();
 &get_user_ship_pos::submarine();
 &get_user_ship_pos::patrol();
}

sub game_play::start () {
 $main::game_play::whos_first = &game_play::decide();
 $main::game_play::mode = &game_play::mode();
 &game_play::tree_branches($main::game_play::whos_first, $main::game_play::mode);
}

#*******************************************************************************
#*********************COMPUTER SHIP GENERATION FUNCTIONS************************
#*******************************************************************************

sub generate_ship_pos::carrier () {
 while (@main::com_ships::com_carrier != 5) {
   my $x = int(rand(9));
   my $y = int(rand(9));
   my $orient = int(rand(1000));
   if ($orient < 500) {
       if ($y <= 2) {
         @main::com_ships::com_carrier = ("$x" . "$y", "$x" . "$y"+1, "$x" . "$y"+2, "$x" . "$y"+3, "$x" . "$y"+4);
       }
       if ($y > 2 and $y <= 6) {
         @main::com_ships::com_carrier = ("$x" . "$y"-2, "$x" . "$y"-1, "$x" . "$y", "$x" . "$y"+1, "$x" . "$y"+2);
       }
       if ($y > 6) {
         @main::com_ships::com_carrier = ("$x" . "$y"-4, "$x" . "$y"-3, "$x" . "$y"-2, "$x" . "$y"-1, "$x" . "$y");
       }
   }
   if ($orient > 500) {
       if ($x <= 2) {
         @main::com_ships::com_carrier = ("$x" . "$y", "$x"+1 . "$y", "$x"+2 . "$y", "$x"+3 . "$y", "$x"+4 . "$y");
       }
       if ($x > 2 and $x <= 6) {
         @main::com_ships::com_carrier = ("$x"-2 . "$y", "$x"-1 . "$y", "$x" . "$y", "$x"+1 . "$y", "$x"+2 . "$y");
       }
       if ($x > 6) {
         @main::com_ships::com_carrier = ("$x"-4 . "$y", "$x"-3 . "$y", "$x"-2 . "$y", "$x"-1 . "$y", "$x" . "$y");
       }
   }
   push @main::com_ships::com_all_ships, @main::com_ships::com_carrier;
 }
}

sub generate_ship_pos::battleship () {
 while (@main::com_ships::com_battleship != 4) {
   my $x = int(rand(9));
   my $y = int(rand(9));
   my $orient = int(rand(1000));
   if ($orient < 500) {
       if ($y <= 2) {
         @main::com_ships::com_battleship = ("$x" . "$y", "$x" . "$y"+1, "$x" . "$y"+2, "$x" . "$y"+3);
       }
       if ($y > 2 and $y <= 6) {
         @main::com_ships::com_battleship = ("$x" . "$y"-2, "$x" . "$y"-1, "$x" . "$y", "$x" . "$y"+1);
       }
       if ($y > 6) {
         @main::com_ships::com_battleship = ("$x" . "$y"-3, "$x" . "$y"-2, "$x" . "$y"-1, "$x" . "$y");
       }
   }
   if ($orient > 500) {
       if ($x <= 2) {
         @main::com_ships::com_battleship = ("$x" . "$y", "$x"+1 . "$y", "$x"+2 . "$y", "$x"+3 . "$y");
       }
       if ($x > 2 and $x <= 6) {
         @main::com_ships::com_battleship = ("$x"-2 . "$y", "$x"-1 . "$y", "$x" . "$y", "$x"+1 . "$y");
       }
       if ($x > 6) {
         @main::com_ships::com_battleship = ("$x"-3 . "$y", "$x"-2 . "$y", "$x"-1 . "$y", "$x" . "$y");
       }
   }
   foreach my $el (@main::com_ships::com_all_ships) {
       foreach my $lee (@main::com_ships::com_battleship) {
         if (($lee + 1 == $el) or ($lee - 1 == $el) or ($lee + 10 == $el) or ($lee - 10 == $el)) {
            @main::com_ships::com_battleship = ();
            last;
         }
       }
    }
    push @main::com_ships::com_all_ships, @main::com_ships::com_battleship;
 }
}

sub generate_ship_pos::destroyer () {
 while (@main::com_ships::com_destroyer != 3) {
   my $x = int(rand(9));
   my $y = int(rand(9));
   my $orient = int(rand(1000));
   if ($orient < 500) {
       if ($y <= 2) {
         @main::com_ships::com_destroyer = ("$x" . "$y", "$x" . "$y"+1, "$x" . "$y"+2);
       }
       if ($y > 2 and $y <= 6) {
         @main::com_ships::com_destroyer = ("$x" . "$y"-1, "$x" . "$y", "$x" . "$y"+1);
       }
       if ($y > 6) {
         @main::com_ships::com_destroyer = ("$x" . "$y"-2, "$x" . "$y"-1, "$x" . "$y");
       }
   }
   if ($orient > 500) {
       if ($x <= 2) {
         @main::com_ships::com_destroyer = ("$x" . "$y", "$x"+1 . "$y", "$x"+2 . "$y");
       }
       if ($x > 2 and $x <= 6) {
         @main::com_ships::com_destroyer = ("$x"-1 . "$y", "$x" . "$y", "$x"+1 . "$y");
       }
       if ($x > 6) {
         @main::com_ships::com_destroyer = ("$x"-2 . "$y", "$x"-1 . "$y", "$x" . "$y");
       }
   }
   foreach my $el (@main::com_ships::com_all_ships) {
       foreach my $lee (@main::com_ships::com_destroyer) {
         if (($lee + 1 == $el) or ($lee - 1 == $el) or ($lee + 10 == $el) or ($lee - 10 == $el)) {
            @main::com_ships::com_destroyer = ();
            last;
         }
       }
    }
    push @main::com_ships::com_all_ships, @main::com_ships::com_destroyer;
 }
}

sub generate_ship_pos::submarine () {
 while (@main::com_ships::com_submarine != 3) {
   my $x = int(rand(9));
   my $y = int(rand(9));
   my $orient = int(rand(1000));
   if ($orient < 500) {
       if ($y <= 2) {
         @main::com_ships::com_submarine = ("$x" . "$y", "$x" . "$y"+1, "$x" . "$y"+2);
       }
       if ($y > 2 and $y <= 6) {
         @main::com_ships::com_submarine = ("$x" . "$y"-1, "$x" . "$y", "$x" . "$y"+1);
       }
       if ($y > 6) {
         @main::com_ships::com_submarine = ("$x" . "$y"-2, "$x" . "$y"-1, "$x" . "$y");
       }
   }
   if ($orient > 500) {
       if ($x <= 2) {
         @main::com_ships::com_submarine = ("$x" . "$y", "$x"+1 . "$y", "$x"+2 . "$y");
       }
       if ($x > 2 and $x <= 6) {
         @main::com_ships::com_submarine = ("$x"-1 . "$y", "$x" . "$y", "$x"+1 . "$y");
       }
       if ($x > 6) {
         @main::com_ships::com_submarine = ("$x"-2 . "$y", "$x"-1 . "$y", "$x" . "$y");
       }
   }
   foreach my $el (@main::com_ships::com_all_ships) {
       foreach my $lee (@main::com_ships::com_submarine) {
         if (($lee + 1 == $el) or ($lee - 1 == $el) or ($lee + 10 == $el) or ($lee - 10 == $el)) {
            @main::com_ships::com_submarine = ();
            last;
         }
       }
    }
    push @main::com_ships::com_all_ships, @main::com_ships::com_submarine;
 }
}

sub generate_ship_pos::patrol () {
 while (@main::com_ships::com_patrol != 2) {
   my $x = int(rand(9));
   my $y = int(rand(9));
   my $orient = int(rand(1000));
   if ($orient < 500) {
       if ($y <= 2) {
         @main::com_ships::com_patrol = ("$x" . "$y", "$x" . "$y"+1);
       }
       if ($y > 2 and $y <= 6) {
         @main::com_ships::com_patrol = ( "$x" . "$y", "$x" . "$y"+1);
       }
       if ($y > 6) {
         @main::com_ships::com_patrol = ("$x" . "$y"-1, "$x" . "$y");
       }
   }
   if ($orient > 500) {
       if ($x <= 2) {
         @main::com_ships::com_patrol = ("$x" . "$y", "$x"+1 . "$y");
       }
       if ($x > 2 and $x <= 6) {
         @main::com_ships::com_patrol = ("$x" . "$y", "$x"+1 . "$y");
       }
       if ($x > 6) {
         @main::com_ships::com_patrol = ("$x"-1 . "$y", "$x" . "$y");
       }
   }
   foreach my $el (@main::com_ships::com_all_ships) {
       foreach my $lee (@main::com_ships::com_patrol) {
         if (($lee + 1 == $el) or ($lee - 1 == $el) or ($lee + 10 == $el) or ($lee - 10 == $el)) {
            @main::com_ships::com_patrol = ();
            last;
         }
       }
    }
    push @main::com_ships::com_all_ships, @main::com_ships::com_patrol;
 }
}

sub generate_ship_pos::correctional() {
 foreach my $el (@main::com_ships::com_all_ships) {
   if (length $el == 1) {
       $el = '0' . "$el";
   }
 }
}
#*******************************************************************************
#************************USER SHIP GENERATION FUNCTIONS*************************
#*******************************************************************************

sub get_user_ship_pos::carrier () {
 my @user_carrier_check_let = ();
 my @user_carrier_check_num = ();
 my $input = '';
 my $decide = 1;
 print "\n   1 2 3 4 5 6 7 8 9 10\n";
 print "   --------------------\n";
 my $i = 0;
 foreach my $el (@main::user_ships::user_board) {
   print "$main::letters::letters[$i]|";
   print " @$el\n";
   $i++;
 }
 print "Please enter your carrier positions (e.g. C2): ";
 chomp($input = <STDIN>);
 print $input, "inputted", "\n";
 @main::user_ships::user_carrier = split("", $input);
 print @main::user_ships::user_carrier, "carrier input", "\n";
 


 foreach my $el (@main::user_ships::user_carrier) {   ### use C2 as example
   my ($let) = split('', $el);  ## gdk edit
   my ($one) = split('', $el);   ## gdk edit
   my ($two) = split('', $el);   ## gdk edit
 print $el, "el", $one, "one", $two, "two", "\n";
if ($el eq "C") { 
$let = 2;  ### gdk edit
}

   my $num = 0;
   if ($two == 2) {   ### if ne to a letter else a number so 
      $num = "$one" . "$two";
      $num = $num - 1;
   } else {
      $num = $one - 1;
   } 
   $el = "$let" . "$num";
   print $el, "el again", "\n";
### gdk edit warning
   push @user_carrier_check_let, $let;
   push @user_carrier_check_num, $num;
 }
 @user_carrier_check_let = sort {$a <=> $b} @user_carrier_check_let;
 
 @user_carrier_check_num = sort {$a <=> $b} @user_carrier_check_num;
 my $string_alet = $user_carrier_check_let[0] . $user_carrier_check_let[1] . $user_carrier_check_let[2] . $user_carrier_check_let[3] . $user_carrier_check_let[4];
 my $string_anum = $user_carrier_check_num[0] . $user_carrier_check_num[1] . $user_carrier_check_num[2] . $user_carrier_check_num[3] . $user_carrier_check_num[4];
 print $string_alet, " alet ", $string_anum, " anum", "\n";
 

 foreach my $el (@main::user_ships::user_carrier) {
my ($let) = split('', $el);  ### gdk edit
my ($num) = split('', $el);  ### gdk edit
   $main::user_ships::user_board[$let][$num] = "#";
 }
 push @main::user_ships::user_all_ships, @main::user_ships::user_carrier;
}


sub get_user_ship_pos::battleship () {
 my @user_battleship_check_let = ();
 my @user_battleship_check_num = ();
 my $input = '';
 my $decide = 1;
 print "\n   1 2 3 4 5 6 7 8 9 10\n";
 print "   --------------------\n";
 my $i = 0;
 foreach my $el (@main::user_ships::user_board) {
   print "$main::letters::letters[$i]|";
   print " @$el\n";
   $i++;
 }
 print "Please enter your battleship positions (e.g. G6): ";
 chomp($input = <STDIN>);
 @main::user_ships::user_battleship = split("", $input);


 foreach my $el (@main::user_ships::user_battleship) {    ### use G6 as example
   my ($let) = split('', $el);  ## gdk edit
   my ($one) = split('', $el);   ## gdk edit
   my ($two) = split('', $el);   ## gdk edit
 print $el, "el", $one, "one", $two, "two", "\n";
if ($el eq "G") { 
$let = 6;  ### gdk edit
}
 
   my $num = 0;
   if ($two == 6) {
      $num = "$one" . "$two";
      $num = $num - 1;
   } else {
      $num = $one - 1;
   } 
   $el = "$let" . "$num";
    print $el, "el again", "\n";
### gdk edit warning
   push @user_battleship_check_let, $let;
   push @user_battleship_check_num, $num;
 }

 @user_battleship_check_let = sort {$a <=> $b} @user_battleship_check_let;
 @user_battleship_check_num = sort {$a <=> $b} @user_battleship_check_num;
 my $string_alet = $user_battleship_check_let[0] . $user_battleship_check_let[1] . $user_battleship_check_let[2] . $user_battleship_check_let[3];
 my $string_anum = $user_battleship_check_num[0] . $user_battleship_check_num[1] . $user_battleship_check_num[2] . $user_battleship_check_num[3];
 print $string_alet, " alet ", $string_anum, " anum", "\n";
 
 foreach my $el (@main::user_ships::user_battleship) {
   my ($let) = split('', $el);  ### gdk edit
   my ($num) = split('', $el);  ### gdk edit
   
   $main::user_ships::user_board[$let][$num] = "*";
 }
 push @main::user_ships::user_all_ships, @main::user_ships::user_battleship;
}

sub get_user_ship_pos::destroyer () {
 my @user_destroyer_check_let = ();
 my @user_destroyer_check_num = ();
 my $input = '';
 my $decide = 1;
 print "\n   1 2 3 4 5 6 7 8 9 10\n";
 print "   --------------------\n";
 my $i = 0;
 foreach my $el (@main::user_ships::user_board) {
   print "$main::letters::letters[$i]|";
   print " @$el\n";
   $i++;
 }
 print "Please enter your destroyer positions (e.g. B1): ";
 chomp($input = <STDIN>);
 @main::user_ships::user_destroyer = split("", $input);

 foreach my $el (@main::user_ships::user_destroyer) {
   my ($let) = split('', $el);  ## gdk edit
   my ($one) = split('', $el);   ## gdk edit
   my ($two) = split('', $el);   ## gdk edit
 print $el, "el", $one, "one", $two, "two", "\n";
if ($el eq "B") { 
$let = 1;  ### gdk edit
}

   my $num = 0;
   if ($two == 1) {
      $num = "$one" . "$two";
      $num = $num - 1;
   } else {
      $num = $one - 1;
   } 
   $el = "$let" . "$num";
   print $el, "el again", "\n";
### GDK warning
   push @user_destroyer_check_let, $let;
   push @user_destroyer_check_num, $num;
 }

 @user_destroyer_check_let = sort {$a <=> $b} @user_destroyer_check_let;
 @user_destroyer_check_num = sort {$a <=> $b} @user_destroyer_check_num;
 my $string_alet = $user_destroyer_check_let[0] . $user_destroyer_check_let[1] . $user_destroyer_check_let[2];
 my $string_anum = $user_destroyer_check_num[0] . $user_destroyer_check_num[1] . $user_destroyer_check_num[2];
 print $string_alet, " alet ", $string_anum, " anum", "\n";
 
 foreach my $el (@main::user_ships::user_destroyer) {
   my ($let) = split('', $el);  ### gdk edit
   my ($num) = split('', $el);  ### gdk edit
   $main::user_ships::user_board[$let][$num] = "%";
 }
 push @main::user_ships::user_all_ships, @main::user_ships::user_destroyer;
}

sub get_user_ship_pos::submarine () {
 my @user_submarine_check_let = ();
 my @user_submarine_check_num = ();
 my $input = '';
 my $decide = 1;
 print "\n   1 2 3 4 5 6 7 8 9 10\n";
 print "   --------------------\n";
 my $i = 0;
 foreach my $el (@main::user_ships::user_board) {
   print "$main::letters::letters[$i]|";
   print " @$el\n";
   $i++;
 }
 print "Please enter your submarine positions (e.g. F5): ";
 chomp($input = <STDIN>);
 @main::user_ships::user_submarine = split("", $input);

 foreach my $el (@main::user_ships::user_submarine) {
   my ($let) = split('', $el);  ## gdk edit
   my ($one) = split('', $el);   ## gdk edit
   my ($two) = split('', $el);   ## gdk edit
 print $el, "el", $one, "one", $two, "two", "\n";
if ($el eq "F") { 
$let = 5;  ### gdk edit
}

   my $num = 0;
   if ($two == 5) {
      $num = "$one" . "$two";
      $num = $num - 1;
   } else {
      $num = $one - 1;
   } 
   $el = "$let" . "$num";
      print $el, "el again", "\n";
## GDK warning
   push @user_submarine_check_let, $let;
   push @user_submarine_check_num, $num;
 }

 @user_submarine_check_let = sort {$a <=> $b} @user_submarine_check_let;
 @user_submarine_check_num = sort {$a <=> $b} @user_submarine_check_num;
 my $string_alet = $user_submarine_check_let[0] . $user_submarine_check_let[1] . $user_submarine_check_let[2];
 my $string_anum = $user_submarine_check_num[0] . $user_submarine_check_num[1] . $user_submarine_check_num[2];
 print $string_alet, " alet ", $string_anum, " anum", "\n";
 
 foreach my $el (@main::user_ships::user_submarine) {
   my ($let) = split('', $el);  ### gdk edit
   my ($num) = split('', $el);  ### gdk edit
   $main::user_ships::user_board[$let][$num] = "^";
 }
 push @main::user_ships::user_all_ships, @main::user_ships::user_submarine;
}

sub get_user_ship_pos::patrol () {
 my @user_patrol_check_let = ();
 my @user_patrol_check_num = ();
 my $input = '';
 my $decide = 1;
 print "\n   1 2 3 4 5 6 7 8 9 10\n";
 print "   --------------------\n";
 my $i = 0;
 foreach my $el (@main::user_ships::user_board) {
   print "$main::letters::letters[$i]|";
   print " @$el\n";
   $i++;
 }
 print "Please enter your patrol positions (e.g. D3):";
 chomp($input = <STDIN>);
 @main::user_ships::user_patrol = split("", $input);

 foreach my $el (@main::user_ships::user_patrol) {
   my ($let) = split('', $el);  ## gdk edit
   my ($one) = split('', $el);   ## gdk edit
   my ($two) = split('', $el);   ## gdk edit
 print $el, "el", $one, "one", $two, "two", "\n";
if ($el eq "D") { 
$let = 3;  ### gdk edit
}

   my $num = 0;
   if ($two == 3) {
      $num = "$one" . "$two";
      $num = $num - 1;
   } else {
      $num = $one - 1;
   } 
   $el = "$let" . "$num";
      print $el, "el again", "\n";
### GDK warning
   push @user_patrol_check_let, $let;
   push @user_patrol_check_num, $num;
 }

 @user_patrol_check_let = sort {$a <=> $b} @user_patrol_check_let;
 @user_patrol_check_num = sort {$a <=> $b} @user_patrol_check_num;
 my $string_alet = $user_patrol_check_let[0] . $user_patrol_check_let[1];
 my $string_anum = $user_patrol_check_num[0] . $user_patrol_check_num[1];
print $user_patrol_check_let[0], $user_patrol_check_let[1], $user_patrol_check_num[0], $user_patrol_check_num[1], "patrol", "\n";
 print $string_alet, " alet ", $string_anum, " anum", "\n";
 
 foreach my $el (@main::user_ships::user_patrol) {
   my ($let) = split('', $el);  ### gdk edit
   my ($num) = split('', $el);  ### gdk edit
   $main::user_ships::user_board[$let][$num] = "~";
 }
 push @main::user_ships::user_all_ships, @main::user_ships::user_patrol;
}

#*******************************************************************************
#*******************************GAME-PLAY FUNCTIONS*****************************
#*******************************************************************************

sub game_play::decide () {
 my $decide = '';
 while (!$decide) {
   print "\n1. You ($main::startup::name)";
   print "\n2. Computer";
   print "\n3. Random";
   print "\n\nPlease enter digit to decide who goes first: ";
   chomp($decide = <STDIN>);
   if ($decide == 1 or $decide == 2) {
      return $decide;
   } elsif ($decide = 3) {
      return int(rand(1000));
   } else {
      print "Your slection is not recognized. Please try again.\n";
      $decide = '';
   }
 }
}

sub game_play::mode () {
 my $mode = '';
 while (!$mode) {
   print "\n1. Regular";
   print "\n2. Three-shot salvo";
   print "\n\nPlease enter mode selection: ";
   chomp($mode = <STDIN>);
   if ($mode == 1 or $mode == 2) {
      return $mode;
   } else {
      print "Your slection is not recognized. Please try again.\n";
      $mode = '';
   }
 }
}

sub game_play::tree_branches () {
 my @deciders = @_;
 if ($deciders[0]/2 == int($deciders[0]/2)){
   &game_play::com_start($deciders[1]);
 } else {
   &game_play::user_start($deciders[1]);
 }
}

sub game_play::com_start () {
 my ($decider) = @_;
 print "COMPUTER STARTS . . . .\n\n";
 sleep 1;
 if ($decider == 2) {
   &game_play::com_start::salvo_mode();
 } elsif ($decider == 1) {
   &game_play::com_start::reg_mode();
 }
}

sub game_play::user_start () {
 my ($decider) = @_;
 print "$main::startup::name STARTS . . . .\n\n";
 if ($decider == 2) {
   &game_play::user_start::salvo_mode();
 } else {
   &game_play::user_start::reg_mode();
 }
}

sub game_play::com_start::salvo_mode() {

 while (!&game_play::dead_yet()) {

   &game_play::salvo_mode::com_salvo();
   &game_play::dead_yet();

   print "USER BOARD:";
   print "\n   1 2 3 4 5 6 7 8 9 10\n";
   print "   --------------------\n";
   my $i = 0;
   foreach my $el (@main::user_ships::user_board) {
      print "$main::letters::letters[$i]|";
      print " @$el\n";
      $i++;
   }
   print "COMPUTER BOARD:";
   print "\n   1 2 3 4 5 6 7 8 9 10\n";
   print "   --------------------\n";
   $i = 0;
   foreach my $el (@main::com_ships::com_board) {
      print "$main::letters::letters[$i]|";
      print " @$el\n";
      $i++;
   }

   &game_play::salvo_mode::user_salvo();
   &game_play::dead_yet();
 }
}

sub game_play::com_start::reg_mode() {

 while (!&game_play::dead_yet()) {

   &game_play::reg_mode::com_shot();
   &game_play::dead_yet();

   print "USER BOARD:";
   print "\n   1 2 3 4 5 6 7 8 9 10\n";
   print "   --------------------\n";
   my $i = 0;
   foreach my $el (@main::user_ships::user_board) {
      print "$main::letters::letters[$i]|";
      print " @$el\n";
      $i++;
   }
   print "COMPUTER BOARD:";
   print "\n   1 2 3 4 5 6 7 8 9 10\n";
   print "   --------------------\n";
   $i = 0;
   foreach my $el (@main::com_ships::com_board) {
      print "$main::letters::letters[$i]|";
      print " @$el\n";
      $i++;
   }

   &game_play::reg_mode::user_shot();
   &game_play::dead_yet();
 }
}


sub game_play::user_start::salvo_mode() {

 while (!&game_play::dead_yet()) {

   print "USER BOARD:";
   print "\n   1 2 3 4 5 6 7 8 9 10\n";
   print "   --------------------\n";
   my $i = 0;
   foreach my $el (@main::user_ships::user_board) {
      print "$main::letters::letters[$i]|";
      print " @$el\n";
      $i++;
   }
   print "COMPUTER BOARD:";
   print "\n   1 2 3 4 5 6 7 8 9 10\n";
   print "   --------------------\n";
   $i = 0;
   foreach my $el (@main::com_ships::com_board) {
      print "$main::letters::letters[$i]|";
      print " @$el\n";
      $i++;
   }

   &game_play::salvo_mode::user_salvo();
   &game_play::dead_yet();
   &game_play::salvo_mode::com_salvo();
   &game_play::dead_yet();
 }
}

sub game_play::user_start::reg_mode() {

 while (!&game_play::dead_yet()) {

   print "USER BOARD:";
   print "\n   1 2 3 4 5 6 7 8 9 10\n";
   print "   --------------------\n";
   my $i = 0;
   foreach my $el (@main::user_ships::user_board) {
      print "$main::letters::letters[$i]|";
      print " @$el\n";
      $i++;
   }
   print "COMPUTER BOARD:";
   print "\n   1 2 3 4 5 6 7 8 9 10\n";
   print "   --------------------\n";
   $i = 0;
   foreach my $el (@main::com_ships::com_board) {
      print "$main::letters::letters[$i]|";
      print " @$el\n";
      $i++;
   }

   &game_play::reg_mode::user_shot();
   &game_play::dead_yet();
   &game_play::reg_mode::com_shot();
   &game_play::dead_yet();
 }
}

sub game_play::salvo_mode::com_salvo () {
 my $x1 = int(rand(10));
 my $y1 = int(rand(10));
 my $x2 = int(rand(10));
 my $y2 = int(rand(10));
 my $x3 = int(rand(10));
 my $y3 = int(rand(10));
 my @temp_checker = ("$x1" . "$y1", "$x2" . "$y2", "$x3" . "$y3");
 if (($main::user_ships::user_board[$x1][$y1] eq 'X') or ($main::user_ships::user_board[$x1][$y1] eq 'O')) {
   &game_play::salvo_mode::com_salvo;
   return;
 }
 if (($main::user_ships::user_board[$x3][$y3] eq 'X') or ($main::user_ships::user_board[$x3][$y3] eq 'O')) {
   &game_play::salvo_mode::com_salvo;
   return;
 }
 if (($main::user_ships::user_board[$x2][$y2] eq 'X') or ($main::user_ships::user_board[$x2][$y2] eq 'O')) {
   &game_play::salvo_mode::com_salvo;
   return;
 }
 push @main::game_play::com_shots_check, @temp_checker;
 if (($main::user_ships::user_board[$x1][$y1] eq '#') or ($main::user_ships::user_board[$x1][$y1] eq '*') or ($main::user_ships::user_board[$x1][$y1] eq '%') or ($main::user_ships::user_board[$x1][$y1] eq '~') or ($main::user_ships::user_board[$x1][$y1] eq '^')) {
   print "You've been hit!\n";
   $main::user_ships::hits++;
   $main::user_ships::user_board[$x1][$y1] = 'X';
 } elsif ($main::user_ships::user_board[$x1][$y1] eq 'X') {
   &game_play::salvo_mode::com_salvo;
   return;
 } else {
   $main::user_ships::user_board[$x1][$y1] = 'O';
 }
if (($main::user_ships::user_board[$x2][$y2] eq '#') or ($main::user_ships::user_board[$x2][$y2] eq '*') or ($main::user_ships::user_board[$x2][$y2] eq '%') or ($main::user_ships::user_board[$x2][$y2] eq '~') or ($main::user_ships::user_board[$x2][$y2] eq '^')) {
   print "You've been hit!\n";
   $main::user_ships::hits++;
   $main::user_ships::user_board[$x2][$y2] = 'X';
 } elsif ($main::user_ships::user_board[$x2][$y2] eq 'X') {
   &game_play::salvo_mode::com_salvo;
   return;
 } else {
   $main::user_ships::user_board[$x2][$y2] = 'O';
 }
if (($main::user_ships::user_board[$x3][$y3] eq '#') or ($main::user_ships::user_board[$x3][$y3] eq '*') or ($main::user_ships::user_board[$x3][$y3] eq '%') or ($main::user_ships::user_board[$x3][$y3] eq '~') or ($main::user_ships::user_board[$x3][$y3] eq '^')) {
   print "You've been hit!\n";
   $main::user_ships::hits++;
   $main::user_ships::user_board[$x3][$y3] = 'X';
  } elsif ($main::user_ships::user_board[$x3][$y3] eq 'X') {
   &game_play::salvo_mode::com_salvo;
   return;
  } else {
   $main::user_ships::user_board[$x3][$y3] = 'O';
  }
}

sub game_play::salvo_mode::user_salvo () {
 my $input = '';
 print "\n Please enter your three salvo shots (e.g. A4 B6 F4):";
 chomp($input = <STDIN>);
 my @user_shots = split(" ", $input);

   if ($input !~ /^[A-J]\d0?\s[A-J]\d0?\s[A-J]\d0?$/i) {
      print "You've entered invalid salvo shot. Please try again.\n";
      &game_play::salvo_mode::user_salvo();
      return 0;
   }
 
 if ($user_shots[0] eq ($user_shots[1] or $user_shots[2]) or $user_shots[1] eq $user_shots[2]) {
   print "You have entered a co-ordinate twice. Please try again.\n";
   &game_play::salvo_mode::user_salvo();
   return 0;
 }
 foreach my $el (@user_shots) {
   my ($let) = split('', $el);  ## gdk edit
   my ($one) = split('', $el);   ## gdk edit
   my ($two) = split('', $el);   ## gdk edit
   
if ($el eq "A") { 
$let = 0;  ### gdk edit
}

if ($el eq "B") { 
$let = 1;  ### gdk edit
}

if ($el eq "C") { 
$let = 2;  ### gdk edit
}

if ($el eq "D") { 
$let = 3;  ### gdk edit
}

if ($el eq "E") { 
$let = 4;  ### gdk edit
}

if ($el eq "F") { 
$let = 5;  ### gdk edit
}

if ($el eq "G") { 
$let = 6;  ### gdk edit
}

if ($el eq "H") { 
$let = 7;  ### gdk edit
}

if ($el eq "I") { 
$let = 8;  ### gdk edit
}

if ($el eq "J") { 
$let = 9;  ### gdk edit
}



   my $num = 0;
   if ($two ne "") {
      $num = "$one" . "$two";
      $num = $num - 1;
   } else {
      $num = $one - 1;
   }
   $el = "$let" . "$num";
### GDK warning
   foreach my $lee (@main::game_play::user_shots_check) {
      if ($el eq $lee) {
          print "You have entered invalid user shot. Please try again.\n";
          &game_play::salvo_mode::user_salvo();
          return;
      }
   }
   foreach my $lee (@main::com_ships::com_all_ships) {

      if ($el eq $lee) {
          print "Computer ship hit!\n";
          $main::com_ships::com_board[$let][$num] = 'X';
          $main::com_ships::hits++;
          last;
      } elsif ($el ne $lee) {
          $main::com_ships::com_board[$let][$num] = 'O';
      }
   }
 }
 push @main::game_play::user_shots_check, @user_shots;
}

sub game_play::reg_mode::com_shot () {
 my $x1 = int(rand(10));
 my $y1 = int(rand(10));
 my $temp_checker = ("$x1" . "$y1");
 if (($main::user_ships::user_board[$x1][$y1] eq 'X') or ($main::user_ships::user_board[$x1][$y1] eq 'O')) {
   &game_play::reg_mode::com_shot;   ### all ships were already hit and the last choice by computer caused error: out of memory! attempt to free unreferenced scalar at battleship.pl line 938, <STDIN> line 117.
   return;
 }
 push @main::game_play::com_shots_check, $temp_checker;
 if (($main::user_ships::user_board[$x1][$y1] eq '#') or ($main::user_ships::user_board[$x1][$y1] eq '*') or ($main::user_ships::user_board[$x1][$y1] eq '%') or ($main::user_ships::user_board[$x1][$y1] eq '~') or ($main::user_ships::user_board[$x1][$y1] eq '^')) {
   print "You've been hit!\n";
   $main::user_ships::hits++;
   $main::user_ships::user_board[$x1][$y1] = 'X';
 } elsif ($main::user_ships::user_board[$x1][$y1] eq 'X') {
   &game_play::reg_mode::com_shot;
   return;
 } else {
   $main::user_ships::user_board[$x1][$y1] = 'O';
 }
}

sub game_play::reg_mode::user_shot () {
 my $input = '';
 my $choosen = '';
 print "\n Please enter your target: ";
 chomp($input = <STDIN>);
 $choosen = $input;
 my @target_choice = split("", $input);
 if ($input !~ /^[A-J]\d0?$/i) {
      print "You've entered invalid target. Please try again.\n";
      &game_play::reg_mode::user_shot();
      return 0;
 }
 
 foreach my $el (@target_choice) {

   my ($let) = split('', $el);  ## gdk edit
   my ($one) = split('', $el);   ## gdk edit
   my ($two) = split('', $el);   ## gdk edit


if ($el eq "A") { 
$let = 0;  ### gdk edit
}

if ($el eq "B") { 
$let = 1;  ### gdk edit
}

if ($el eq "C") { 
$let = 2;  ### gdk edit
}

if ($el eq "D") { 
$let = 3;  ### gdk edit
}

if ($el eq "E") { 
$let = 4;  ### gdk edit
}

if ($el eq "F") { 
$let = 5;  ### gdk edit
}

if ($el eq "G") { 
$let = 6;  ### gdk edit
}

if ($el eq "H") { 
$let = 7;  ### gdk edit
}

if ($el eq "I") { 
$let = 8;  ### gdk edit
}

if ($el eq "J") { 
$let = 9;  ### gdk edit
}

 my $num = 0;
 if ($two ne "") {
   $num = "$one" . "$two";
   $num = $num - 1;
 } else {
   $num = $one - 1;
 }
 $input = "$let" . "$num";
 print $el, "el again", "\n";
 }
### gdk warning
 foreach my $lee (@main::game_play::user_shots_check) {
   if ($choosen eq $lee) {
      print "You have entered invalid shot check. Please try again.\n";
      &game_play::reg_mode::user_shot();
      return;
   }
 }
 foreach my $lee (@main::com_ships::com_all_ships) {
   if ($choosen eq $lee) {
      print "Computer ship hit!\n";
      $main::com_ships::com_board[$let][$num] = 'X';
      $main::com_ships::hits++;
      last;
   } elsif ($choosen ne $lee) {
      $main::com_ships::com_board[$let][$num] = 'O';
   }
 }
 push @main::game_play::user_shots_check, $el;
}

sub game_play::dead_yet () {
 if ($main::com_ships::hits eq '17') {
   &game_play::end_game(2);
 }
 if ($main::user_ships::hits eq '17') {
   &game_play::end_game(1);
 }
}

sub game_play::end_game () {
 my @winner = @_;
 if ($winner[0] == 2) {
   print "Congratulations! You won, $main::startup::name!\n\n";
   exit;
 } else {
   print "Computer won. Better luck next time!\n";
   exit;
 }
}

sub game_play::THE_END () {
 print "\n";
}

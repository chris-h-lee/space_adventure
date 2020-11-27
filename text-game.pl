/* 
  Text-Based Space Adventure game
  
  Original idea and unfinished base code taken from a class assignment
  
  Modified and improved by Christopher Lee
*/


/* Allow asserts and retracts for these atoms */
:- dynamic at/2.
:- dynamic unlocked/1.
:- dynamic items/1.


/* Initialize some game variables */

unlocked(none).
items(none).
keyToUnlock(key).
canITeleport(teleporter).


/*
  Descriptions of each place in the game.
*/
description(bedroom,
  'You are in the living quarters. Nothing here but a bed and a door in front of you.').
description(hallway,
  'You are in the hallway. There are lockers on either side of you and a doorway down the hall.').
description(locker,
  'You open the locker to the right and crawl inside. There\'s a note here! It says: "...it\'s coming for me...I can hear it growling...but if I can just get to the storage room and find the key....').
description(locker2,
  'Hmm...it looks like there\'s something in this locker...').
description(hub,
  'You are in the main hub. It looks so empty with no one here...').
description(storage(1),
  'You are in storage room 1.').
description(storage(3),
  'You are in storage room 3.').
description(storage(4),
  'You are in storage room 4.').
description(storage(5),
  'You are in storage room 5.').
description(storage(6),
  'You are in storage room 6.').
description(storage(2),
  'You are in storage room 2. You see a scribble on the wall. It reads: "Watch your step when there\'s no light. Go forward, left, then forward, right." Huh, it rhymes that\'s catchy. But all the lights here are on...').
description(storage(0),
  'You are in storage room 0. You found a key on the ground. You should probably pick it up it might come in handy later.').
description(storage(_),
  'You are in the storage area. All these rooms are a giant maze. You can hear faint growling in the distance...').
description(walkway(4),
  'You finally reached the end. Up ahead is the way back to the hub. Wait...what is this? There\'s a strange object on the ground...').
description(walkway(_),
  'You are on the space walkway. It\'s really dark so watch your step!').
description(door,
  'You arrive at a locked door. You must unlock it before moving forward.').
description(detector,
  'You are in a dimly lit hallway. You can hear growling in the darkness on both sides of you. You should be safe as long as you keep quiet. You can see the door to the navigation room at the end just past the ship\'s metal detector. ').
description(navigation,
  'You are in the navigation room.').

/*
  Here are the connections between each location.
  Connections show what direction is needed to get from
  the first place to the second.
*/
connect(bedroom, forward, hallway).
connect(hallway, left, locker2).
connect(hallway, right, locker).
connect(locker, left, hallway).
connect(hallway, forward, hub).
connect(hub, forward, walkway(0)).
connect(walkway(0), forward, walkway(1)).
connect(walkway(1), left, walkway(2)).
connect(walkway(2), forward, walkway(3)).
connect(walkway(3), right, walkway(4)).
connect(walkway(4), forward, hub).
connect(hub, left, storage(1)).
connect(storage(1), right, storage(6)).
connect(storage(6), left, storage(3)).
connect(storage(1), forward, storage(4)).
connect(storage(4), left, storage(2)).
connect(storage(4), forward, storage(5)).
connect(storage(2), forward, storage(3)).
connect(storage(2), right, storage(5)).
connect(storage(3), left, storage(5)).
connect(storage(3), forward, storage(0)).
connect(storage(0), forward, hub).
connect(hub, right, door).
connect(door, left, hub).
connect(door, forward, detector).
connect(detector, forward, navigation).

           
/*
  report prints the description of your current
  location and the items held.
*/

listItems() :-
    not(items(key)),
    not(items(teleporter)),
    write('Your current items are: none. '), nl,
    !.

listItems() :-
    not(items(key)),
    write('Your current items are: teleporter. '), nl,
    !.

listItems() :-
    not(items(teleporter)),
    write('Your current items are: key. '), nl,
    !.

listItems() :-
    write('Your current items are: teleporter, key. '), nl,
    !.
    
report :-
  at(you,X),
  description(X,Y),
  write(Y), nl,
  listItems(),
  !.


/* shortcuts for move */
move(f) :- move(forward).
move(l) :- move(left).
move(r) :- move(right).


/*
	Shorthand for items: picking them up, using them, and dropping them.
*/

pickup(pick) :-
    at(you, storage(0)),
    not(items(key)),
    assert(items(key)),
    write('Picked up a key.\n'),
    !.

pickup(pick) :-
    at(you, walkway(4)),
    not(items(teleporter)),
    assert(items(teleporter)),
    write('Picked up a teleporter.\n'),
    !.

pickup(pick) :-
  write('There is nothing to pick up here.\n'),
  !.

pickup(_).



drop(drop) :-
    write('What item would you like to drop?.\n'),
    read(Item),
    items(Item),
    retract(items(Item)),
    write(Item),write(' has been dropped.\n'),
    !.

drop(drop) :-
    write('That item was not found.\n'),
    !.

drop(_).


teleport(Item) :-
    at(you, Loc),
    canITeleport(Item),
    write('Where would you like to teleport to? (bedroom, hallway, hub, door, detector, navigation).\n'),
    read(LOCATION),
    description(LOCATION, _),
    write('The strange device starts glowing...\n'), 
    retract(items(teleporter)),
    retract(at(you,Loc)),
  	assert(at(you,LOCATION)),
    report,
    !.

teleport(_).
    

unlockGate(Item) :-
    at(you,door),
    keyToUnlock(Item),
    assert(unlocked(door)),
    write('The door has been unlocked!\n'),
    !.

unlockGate(_).

use(use) :-
    write('What item would you like to use?.\n'),
    read(Item),
    items(Item),
    call(teleport(Item)),
    call(unlockGate(Item)),
    write('What action do you want to do? (pick, use, drop, or type anything else to continue).\n'),
 	read(Action),
  	call(pickup(Action)),
  	call(drop(Action)),
  	call(use(Action)),
    !.

use(_).



/*
  move(Dir) moves you in direction Dir, then
  prints the description of your new location.
*/

/* If you try to move past the detector with an item in your
   inventory, the metal detector will beep and you will die
*/
move(Dir) :-
    at(you, detector),
    connect(detector, Dir, navigation), 
    (items(key); items(teleporter)),
    write('BEEEEEEP! The metal detector caught something in your pocket! Oh no! The aliens heard the sound from the shadows and jumped on top of you. You were eaten by aliens...'),
    retract(at(you,Loc)),
  	assert(at(you,done)),
    !.

/* Can only move past the door if it's unlocked
 */
move(Dir) :-
    at(you, door),
    connect(door, Dir, detector), 
    unlocked(door),
    write('--'),write(Dir),write('-----'),
    retract(at(you,door)),
  	assert(at(you,detector)),
  	report,
    write('What action do you want to do? (pick, use, drop, or type anything else to continue).\n'),
 	read(Action),
  	call(pickup(Action)),
  	call(drop(Action)),
  	call(use(Action)),
    !.

/* allows moving left when at the door to return to hub
*/
move(Dir) :-
    at(you, door),
    connect(door, Dir, hub),
    write('--'),write(Dir),write('-----'),
    retract(at(you,door)),
  	assert(at(you,hub)),
  	report,
    write('What action do you want to do? (pick, use, drop, or type anything else to continue).\n'),
  	read(Action),
  	call(pickup(Action)),
  	call(drop(Action)),
  	call(use(Action)),
    !.
/* handles move(Dir) instructions when NOT at the door
*/

move(Dir) :-
  not(at(you,door)),
  write('--'),write(Dir),write('-----'),
  at(you,Loc),
  connect(Loc,Dir,Next),
  retract(at(you,Loc)),
  assert(at(you,Next)),
  report,
  write('What action do you want to do? (pick, use, drop, or type anything else to continue).\n'),
  read(Action),
  call(pickup(Action)),
  call(drop(Action)),
  call(use(Action)),
  !.

/* If the direction is not a legal direction and the user is on
 * the space walkway, they will fall off and die
 */

move(_) :-
    at(you, walkway(_)),
    write('Oh no! You lost your footing and plunged into the cold darkness of space...'),
    retract(at(you,Loc)),
  	assert(at(you,done)),
    !.

/* If you are in the detector and you move left or right, you die.
 */ 

move(_) :-
    at(you, detector),
    write('You walk into the darkness only to be met face to face with an alien. You die.'),
    retract(at(you,Loc)),
  	assert(at(you,done)),
    !.

/*
  Otherwise, if the argument was not a legal direction,
  print an error message and don't move.
*/
move(_) :-
  write('There\'s nothing in that direction.\n'),
  report.


/*
  If you go to the place where the alien is hiding, you die.
*/

alien :-
  at(you, storage(5)),
  write('Out of nowhere an alien jumps at you and bites your head off. You die.'),
  retract(at(you,Loc)),
  assert(at(you,done)),
  !.

alien.

/*
  If you are at the navigation room, you win!
*/
nav :-
  at(you,navigation),
  write('Congrats! You finally made it to the navigation room! Now you can fly safely home.'),
  retract(at(you,Loc)),
  assert(at(you,done)),
  !.

nav.

/* If you crawl into the wrong locker, you die.
 */ 

bad :-
  at(you,locker2),
  write('Oh it was an alien. Well at least now you know not to look into random lockers right?'),
  retract(at(you,Loc)),
  assert(at(you,done)),
  !.

bad.

/*
 Stop the game when conditions are met
*/
main :- 
  at(you,done),
  write('Thanks for playing.\n'),
  !.
/*
  Main loop
*/
main :-
  write('\nNext move -- '),
  read(Move),
  call(move(Move)),
  alien,
  nav,
  bad,
  main.

/* Start game
*/    
go :-
  retractall(items(_)),
  retractall(at(_,_)), % clean up from previous runs
  assert(at(you,bedroom)),
  write('Welcome to this text-based space adventure game. \n'),
  write('Aliens have invaded your spaceship and you are the only surviving crew member. \n'),
  write('You must find your way to the navigation room without dying. \n'),
  write('Legal moves are (l)eft, (r)ight, or (f)orward.\n'),
  report,
  main.
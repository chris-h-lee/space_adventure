# Text-Based Space Adventure game


Introduction
------------

This is a text-based adventure game written entirely in Prolog. The original idea was based off of a class assignment, in which we were given an unfinished skeleton game code to work with. After completing the assignment, I decided it would be fun to rewrite and improve the game as a fun little side project. I've added a new map, new features, and new gameplay mechanics to make a more complete game. While using Python would've been much easier to implement, I figured this would be a good way to practice Prolog and code using data and queries.

The Game
--------

You and your crew's spaceship was attacked and invaded by alien life forms. You wake up, realizing you're the only surviving crewmember left. You have to make your way through the ship to the navigation room without getting eaten by aliens or accidentally falling into the depths of space. There are helpful items hidden along the way that will aid you on your journey. Can you survive and pilot the ship to safety?

Instructions
------------

Using https://swish.swi-prolog.org/ or any other program, run the provided .pl file. Then, type "go." into the query box in the bottom-right corner and press "Run!". This will start the game. You have three possible moves: (L)eft, (F)orward, and (R)ight. To move, type the direction into the input box and press enter. After moving, the game will ask if you want to perform an action. The possible actions are: pick, drop, and use. Pick will try to pick up an item from the ground. Drop will let you drop any item currently in your inventory. Use will let you use an item in your inventory at your current location. Typing anything else into the input box skips the action phase. 

Hints
-----

A rough map of the spaceship can be found in this repository. It's not 100% accurate to the correct directions, but it gives a good overview of how the game is laid out. Icons such as the lock and key show where important locations are in the game, and "X" marks represent death spots. 

A special feature in this game is the teleporter item. It can be found in the space walkway if the correct sequence of moves are given. The pattern can be found somewhere on the ship. This is important as a single wrong move on the walkway results in death. Once obtained, using the teleporter will allow you to type the location of any place on the ship, including straight to "navigation", which will instantly let you win the game.

Example Runthroughs:
--------------------

Here are a couple of full runthroughs of the game. I have listed the commands needed to be entered into the input box one at a time in order to result in a successful game.

Method 1: 
f, f, f, f, l, l, r, r, l, l, f, pick, f, f, r, use, key, f, f, drop, key, f, f

Method 2:
f, f, f, f, f, f, f, f, l, l, f, f, r, pick, f, use, teleporter, navigation, f


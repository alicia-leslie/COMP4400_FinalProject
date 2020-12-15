:- dynamic(current_location/1, holding/1, item_location/2, visible_obj/1, flashlight_on/0, dark/1, locked/1, unlocked/1, lit/1, can_open/1).

/* Initial Settings */
current_location(porch).

/* Determines how the locations are connected and by what directions */
path(porch, enter, foyer).
path(foyer, leave, porch).

path(foyer, e, dining_room).
path(foyer, w, study).
path(foyer, n, stairs).

path(dining_room, w, foyer).
path(dining_room, n, kitchen).

path(study, e, foyer).
path(study, n, living_room).

path(stairs, u, upstairs_hall).
path(stairs, d, cellar).
path(stairs, s, foyer).

path(kitchen, s, dining_room).
path(kitchen, w, living_room).
path(kitchen, n, back_door).

path(living_room, s, study).
path(living_room, e, kitchen).

path(back_door, n, shed).
path(back_door, s, kitchen).
path(back_door, e, well).

path(shed, s, back_door).
path(well, w, back_door).

path(upstairs_hall, w, closet).
path(upstairs_hall, n, bathroom).
path(upstairs_hall, e, bedroom).
path(upstairs_hall, s, stairs).

path(closet, e, upstairs_hall).

path(bathroom, s, upstairs_hall).

path(bedroom, w, upstairs_hall).
path(bedroom, n, bedroom_closet).

path(bedroom_closet, s, bedroom).
path(bedroom_closet, n, secret_room).

path(cellar, u, stairs).

path(secret_room, s, bedroom_closet). 

/* Determines which locations are dark initially */
dark(cellar).
dark(secret_room).
dark(shed).
dark(bedroom).
dark(bedroom_closet).
dark(kitchen).

/* Determines which locations are unlocked initially */
unlocked(porch).
unlocked(foyer).
unlocked(study).
unlocked(stairs).
unlocked(dining_room).
unlocked(upstairs_hall).
unlocked(closet).
unlocked(living_room).
unlocked(back_door).
unlocked(bedroom).
unlocked(cellar).
unlocked(bathroom).
unlocked(bedroom_closet).
unlocked(well).
unlocked(kitchen).
unlocked(secret_room).

/* Determines which locations are locked initially */
locked(shed).

/* The below rules define where the items are initially located on the map */
item_location(wire_coat_hanger, closet).
item_location(flashlight, foyer).
item_location(fridge, kitchen).
item_location(rope, cellar).
item_location(sewer_grate, cellar).
item_location(bucket, shed).
item_location(newspaper, study).
item_location(desk, study).
item_location(table, dining_room).
item_location(cabinet, dining_room).
item_location(fireplace, living_room).
item_location(small_note, bathroom).
item_location(safe, secret_room).

/* Determines which items are initially visible */ 
visible_obj(end_table).
visible_obj(newspaper).
visible_obj(flashlight).
visible_obj(desk).
visible_obj(table).
visible_obj(cabinet).
visible_obj(fireplace).
visible_obj(wire_coat_hanger).
visible_obj(small_note).
visible_obj(priceless_painting).

/* Defines the fireplace as initially being lit with fire */
lit(fireplace).

/* The below rules define how users can take objects */
take(fridge) :-
        current_location(kitchen),
        \+dark(kitchen),
        visible_obj(fridge),
        write('This is too heavy for you to take... maybe there is something inside though...I can look further into this by using the inspect(fridge). command'),
        nl, !, fail.
        
take(sewer_grate) :-
        current_location(cellar),
        \+dark(cellar),
        visible_obj(sewer_grate),
        write('This is very heavy and large, I cannot take it will be... I can try an open it though'),
        nl, !, fail.

take(key) :-
        current_location(sewer_grate),
        \+item_location(wire_coat_hanger, in_inventory),
        write('This is too far down for me to reach... If I had some sort of wire, maybe I could use it to fish the key out...'),
        nl, !, fail.
        
take(desk) :-
        current_location(study),
        write('This is too heavy for you to take... maybe there is something inside though...I can look further into this by using the inspect(desk). command'),
        nl, !, fail.
        
take(table) :-
        current_location(dining_room),
        write('This is too heavy for you to take...'),
        nl, !, fail.
        
take(cabinet) :-
        current_location(dining_room),
        write('This is too heavy for you to take... maybe there is something inside though...I can look further into this by using the inspect(cabinet). command'),
        nl, !, fail.
        
take(fireplace) :-
        current_location(living_room),
        write('You cannot take this... it is built into the house... I can look further into this by using the inspect(fireplace). command'),
        nl, !, fail.
        
take(safe) :-
        current_location(secret_room),
        write('You cannot take this... it is built into the wall... I can look further into this by using the inspect(safe). command'),
        nl, !, fail.
        
take(X) :-
        item_location(X, in_inventory),
        write('You cannot take this item, it is already in your inventory...'),
        nl, !.

take(X) :-
        current_location(Place),
        item_location(X, Place),
        retract(item_location(X, Place)),
        asserta(item_location(X, in_inventory)),
        write('You have picked up a '), write(X),nl,
        inspect(X),
        !, nl.

take(_) :-
        write('I do not see that object here...'),
        nl.

/* The below rule defines how the user can view their inventory contents */
inventory :-
        item_location(X, in_inventory),
        write('There is a '), write(X), write(' in your inventory.'), 
        nl, fail.
        
/* The below rules defines what is currently in the users hand, it is initialized when the users selects to use an object */
using :-
        holding(X),
        write('You are holding the '), write(X), write('.'),
        nl, fail.

/* The below rules define how the user can use different types of objects */
use(flashlight) :-
		item_location(flashlight, in_inventory),
		\+item_location(battery, in_inventory),
		write('The flash light has no battery... maybe I should try and find one... for now, I will put it back into my inventory'), nl, !, fail.

use(flashlight) :-
		item_location(flashlight, in_inventory),
		item_location(battery, in_inventory),
		asserta(holding(flashlight)),
		write('The flash light turns on'), nl,
		flashlight_on,
		!.
		
use(bucket) :-
		current_location(well),
		item_location(bucket, in_inventory),
		\+item_location(rope, in_inventory),
		write('I cannot reach the water, it is too deep in the well... Maybe if I had some sort of long rope in my inventory, I could use the bucket to get water'), nl, !, fail.

use(bucket) :-
		current_location(well),
		item_location(bucket, in_inventory),
		item_location(rope, in_inventory),
		asserta(holding(bucket)),
		asserta(filled(bucket)),
		write('You lower the bucket into the well using the rope and it slowly fills with water, you pull on the rope to drag it back up to the surface'), nl,
		!.
		
use(bucket) :-
		current_location(living_room),
		lit(fireplace),
		item_location(bucket, in_inventory),
		filled(bucket),
		asserta(holding(bucket)),
		asserta(can_open(fireplace)),
		retract(lit(fireplace)),
		write('You throw the bucket of water onto the fire and it goes out... now you can safetly open the fireplace'), nl, !.
		
use(key) :-
		item_location(key, in_inventory),
		asserta(holding(key)),
		current_location(back_door),
		asserta(unlocked(shed)),
		retract(locked(shed)),
		!.
		
use(X) :-
        item_location(X, in_inventory), 
        asserta(holding(X)),
        !.
        
use(_) :-
        write('You cannot use that item...'), nl, !, fail.
        
/* The below rules define how the user can inspect items and give a description of each item, the user may only inspect most items when they are in their inventory */
inspect(priceless_painting) :-
		item_location(priceless_painting, in_inventory),
        write('This is the priceless painting that was stolen so many months ago... I better keep this safe and get out of here...'), 
        nl.

inspect(soggy_note) :-
		item_location(soggy_note, in_inventory),
        write('The ink is smeared a bit, but it is clear to see that "2.w" is written... I wonder what this means'), 
        nl.
        
inspect(newspaper) :-
		item_location(newspaper, in_inventory),
        write('The newspaper is dated from a couple months ago, surprisngly recent... The front page headline discusses the priceless painting that was stolen from the museum... The exact painting you are searching for...'), 
        nl.
        
inspect(small_note) :-
		item_location(small_note, in_inventory),
        write('The note is a thin piece of paper with very small writing... "1.z" is written on it... I wonder what this means'), 
        nl.
        
inspect(scorched_note) :-
		item_location(scorched_note, in_inventory),
        write('The edges of the paper are burnt up, but somehow the middle is untouched... "3.x" is written on it... I wonder what this means'), 
        nl.
  
 inspect(flashlight) :-
		item_location(flashlight, in_inventory),
        write('It is a typical flashlight, it needs a battery to be powered on.'), 
        nl.    
        
  inspect(battery) :-
		item_location(battery, in_inventory),
        write('It is a single battery... If I am also carrying something that needs power, this could be useful...'), 
        nl.    
        
   inspect(bucket) :-
		item_location(bucket, in_inventory),
        write('It is a blue bucket with a wire handle that a rope could be attached to... This could hold enough water to put out a large fire...'), 
        nl.
        
   inspect(rope) :-
		item_location(rope, in_inventory),
        write('It is a long rope made out of fibers... I would be able to tie this around something if I wanted to....'), 
        nl.
        
   inspect(book) :-
		item_location(book, in_inventory),
        write('It is a leather bound journal with an intricate broken lock... All the pages are blank except for one... it says "put out the fire"...what could that be refering to?'), 
        nl.   
        
    inspect(key) :-
		item_location(key, in_inventory),
        write('It is a small metalic key... It has a label on it that says "back shed"...'), 
        nl.    
               
   inspect(wire_coat_hanger) :-
		item_location(wire_coat_hanger, in_inventory),
        write('It is a typical thin wire coat hanger, I could probably un-bend this and use it as some type of hook...'), 
        nl. 
        
 inspect(fridge) :-
		visible_obj(fridge),
		current_location(kitchen),
        write('It is an old white refrigerator... it is too heavy to take with me, but it looks like I can open it'), 
        nl.      
        
  inspect(safe) :-
		visible_obj(safe),
		current_location(secret_room),
        write('It is a large safe built into the back wall of this room, it has the option to enter a 3 digit code... I can use the enter_code(_,_,_). command to enter the combination...'), 
        nl.      

 inspect(sewer_grate) :-
 		visible_obj(sewer_grate),
		current_location(cellar),
        write('It is a heavy iron grate, maybe for water drainage... I can probably pry it open...'), 
        nl, fail.   

 inspect(desk) :-
		current_location(study),
        write('It is a heavy regal desk that seems to be bolted to the floor, there are some drawers that I may be able to open...'), 
        nl.      
        
 inspect(table) :-
		current_location(dining_room),
        write('It is a dusty large table... It looks like no one has sat here in years... there is a note scribbled in the dust that says "get the water from the well"... creepy...'), 
        nl.  
        
  inspect(cabinet) :-
		current_location(dining_room),
        write('It is solid wood cabinet with golden hardware and glassdoors, I could try to open it...'), 
        nl.  
        
  inspect(fireplace) :-
		current_location(living_room),
		lit(fireplace),
        write('It is a large stone fireplace in the middle of the room, there is a grate on the opening, somehow, a fire is lit and burning incredibly hot... I would need water to put this fire out so I can see if there is anything inside...'), 
        nl, fail.  
        
 inspect(fireplace) :-
		current_location(living_room),
		\+lit(fireplace),
        write('It is a large stone fireplace in the middle of the room, I have put the fire out now... I could probably open the grate and see if anything is inside...'), 
        nl. 

/* These rules define how to enter the code to get into the safe */
enter_code(z,w,x) :-
		write('The code works and the safe door swings open...'), 
        nl,
		asserta(can_open(safe)),
		open(safe),!.
		
enter_code(_,_,_) :-
		write('The safe flashes red, that code must have been incorrect...'), 
        nl.
  
/* The below rules define which objects can be opened */
can_open(fridge).
can_open(desk).
can_open(cabinet).
can_open(sewer_grate).

/* The below rules define where objects are initially located inside of other objects */
inside(fridge, soggy_note).
inside(desk, battery).
inside(cabinet, book).
inside(fireplace, scorched_note).
inside(sewer_grate, key).
inside(safe, priceless_painting).

/* The below rules define how the user can open different objects and view their contents */
open(X) :-
		can_open(X),
		write('You open the '), write(X), nl,
		look_at_inside_objects(X),
		asserta(current_location(X)).
	       		
look_at_inside_objects(Item) :-
		can_open(Item),
        inside(Item, X),
        asserta(item_location(X, Item)),
        write('There is a '), write(X), write(' inside.'), nl,
        fail.

look_at_inside_objects(_).
        
/* The below rules define the different directional commands */
enter :- go(enter). 

leave :- go(leave). 

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).

u :- go(u).

d :- go(d). 

/* The below rules define how the user can move inbetween locations based on the directional command given */
go(leave) :-
        current_location(foyer),
        item_location(priceless_painting, in_inventory),
        finish,!.

go(Direction) :-
        current_location(Here),
        unlocked(There),
        path(Here, Direction, There),
        retract(current_location(Here)),
        asserta(current_location(There)),
        !, look.

go(_) :-
		current_location(back_door),
		path(back_door, n, shed),
        locked(shed),
        write('The shed is locked... If I had a key I could try and use it and then go that direction again...'),nl, fail, !.
        
 go(_) :-
		current_location(porch),
		path(porch, enter, foyer),
        locked(foyer),
        write('The house has locked behind you... At least you found the painting... Your work is done, enter halt. to end the game.'),nl, fail, !.
        
go(_) :-
        write('You can''t go that way.').

/* The below rules show how the flashlight can be used to illuminiate dark rooms */
flashlight_on :- 
        current_location(cellar),
        make_visible(rope),
        make_visible(sewer_grate),
        write('Your flashlight shines across the damp concrete floor and you spot a rope in the corner of the room, there is also a sewer grate in the middle of the floor... you will remember this... '),nl, write('use the look. command to see further details'), nl.

flashlight_on :- 
        current_location(kitchen),
        make_visible(fridge),
        retract(dark(kitchen)),
        write('Your flashlight locates a fridge on the back wall...you will remember this... '),nl, write('use the look. command to see further details'), nl.
        
 flashlight_on :- 
        current_location(shed),
        make_visible(bucket),
        retract(dark(shed)),
        write('You use your flashlight to scan the small shack...there is a bucket in the corner...you will remember this... '),nl, write('use the look. command to see further details'), nl.
        
 flashlight_on :- 
        current_location(bedroom),
        retract(dark(bedroom)),
        write('You use your flashlight to survery the bedroom...it looks like it has been untouched for years, the little furniture that is left is covered with dusty sheets...'),nl, write('use the look. command to see further details'), nl.
          
 flashlight_on :- 
        current_location(bedroom_closet),
        retract(dark(bedroom_closet)),
        write('You shine the flashlight across the space...no one has lived in this house for years, but there are clothes and boxes stacked up... '),nl, write('use the look. command to see further details'), nl.
        
 flashlight_on :- 
        current_location(secret_room),
        make_visible(safe),
        retract(dark(secret_room)),
        write('You use your flashlight to look around... the room is small, and the ceilings are so low you have to crouch... In the middle of the back wall there is a large safe with a pin pad to enter a code...'),nl, write('use the look. command to see further details'), nl.

/* The below rules allow objects to be made visible when the flashlight is used in a dark room, once an object is discovered via flashlight, the user will remember its location when they return to the room*/               
make_visible(X) :-
	visible_obj(X).

make_visible(X) :-
	asserta(visible_obj(X)).

/* The below rule defines the procedures that take place when the user looks around */
look :-
        current_location(Place),
        describe(Place),
        nl,
        look_at_objects(Place),
        describe_darkness(Place),
        nl.

/* The below rules describe the visible objects in the current location of the user*/   
look_at_objects(Place) :-
        item_location(X, Place),
        visible_obj(X),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

look_at_objects(_).

/* These rules describe the darkness settings in a location */
describe_darkness(Place) :-
		dark(Place),
		holding(flashlight),
		item_location(flashlight, in_inventory),
		item_location(battery, in_inventory),
		write('There are no lights in here, but my flashlight is helping be see...'), nl,
		flashlight_on,
		fail.

describe_darkness(Place) :-
		dark(Place),
		\+holding(flashlight),
		write('It is too dark to see anything... Maybe I can make some light...'), nl,
		fail.
		
/* The below rule defines the finishing logic of the game*/
finish :-
        nl,
        asserta(lock(foyer)),
        retract(unlocked(foyer)),
        write('Your mission was successful and you have recovered the stolen art. The door swings shut behind you and you can hear the lock turn... That was enough excitement for one day... Enter halt. to end the game.'),
        nl.

/* The below rule prints the game instructions*/
instructions :-
        nl,
        write('The following program is written using GNU Prolog.'), nl,
        write('Available commands are:'), nl,
        write('start.             : to begin the game.'), nl,
        write('enter.     : to enter the house from the porch.'), nl,
        write('leave.     : to leave the house from the foyer.'), nl,
        write('n.  s.  e.  w.     : to go either north, south, east, or west.'), nl,
        write('u. d.    : to go either upstairs or downstairse.'), nl,
        write('take(Object).      : to pick up an object.'), nl,
        write('inspect(Object).      : to get details about an object.'), nl,
        write('use(Object).      : to use an object.'), nl,
        write('open(Object).      : to open an object.'), nl,
        write('inventory.      : to view the objects you picked up.'), nl, 
        write('instructions.      : to view the instructions again.'), nl,
        write('look.              : to look around at your surroundings.'), nl,
        write('enter_code(_,_,_).      : might be useful to enter some information.'), nl,
        write('halt.              : to end the game and quit.'), nl,
        nl.

/* The below rule prints the introductory text */
introductions :-
        nl,
        write('You are a detective who has been tasked on finding a priceless painting that was stolen from a museum many months ago...'), nl,
        write('So far, there has been very few leads, however, a couple days ago you received a mysterious phone call...'), nl,
        write('The voice on the other end of the line gave you GPS coordinates, and dropped an old compass off at your door step...'), nl,
        write('This has led you to here, the porch of an abandoned house...'), nl,
        write('This house has been abandoned for so long, that it is no longer registered under anyones name at the local authorities...'), nl,
        write('Rumors have swirled for years about the past of this location, from hauntings, to smugglings, and even a private circus...'), nl,
        write('You are unsure anything will be here, you are even worried about how safe this old house is, as it creaks when the wind whsitles by...'), nl,
        write('But you must continue on, it is your job to investigate every lead, and for some reason, you are drawn to this location...'), nl,
        write('After all, it would be the perfect place to hide something.'), nl,
        nl.

/* The below rule prints out the starting information */
start :-
		introductions,
        instructions,
        look.


/* The below ryles describe the locations */
describe(porch) :- write('You stand on the porch of a rundown home... You have heard the rumors about famous stolen art being stashed among these walls, but could that really be true?'), nl, write('There is only one way to find out... type enter. to go inside.'), nl.
describe(foyer) :- write('You enter into the foyer... there is some light shining through from behind you, creating an ominous glow...'), nl, write('To the west is the study'), nl, write('To the north is the stairway'), nl, write('To the east is the dining room'), nl, write('To leave the house and go to the porch, enter leave.'), nl.
describe(study) :- write('You are in the study, dusty floor to ceiling bookshelves line the walls... There is a window with sheer curtains that is letting just enough light in to let you see your surroundings.'), nl, write('To the east is the foyer'), nl, write('To the north is the living room'),nl.
describe(stairs) :- write('You are on the stairs, the creek as you shift around... the railing is missing posts... this probably would not pass a safety test...'), nl, write('To go to the upstairs hallway, enter u.'), nl, write('To go to the downstairs cellar, enter d.'), nl, write('To go to the foyer, go south'), nl.
describe(dining_room) :- write('You are in the dining room, the ceilings are surprisingly high... there is a single swinging lightbulb hanging from the ceiling in the middle of the room'), nl, write('To the west is the foywer'), nl, write('To the north is the kitchen'),nl.
describe(upstairs_hall) :- write('You enter the upstairs hallway... it is narrow, and lined with old floral wallpaper and pink shag carpet...'), nl, write('To the west is the closet'), nl, write('To the north is the bathroom'), nl, write('To the east is the bedroom'),nl, write('To the south is the stairway'), nl.
describe(living_room) :- write('You enter the living room, it is much more grand than expected, with warm lighting creating a surprisingly cozy yet creepy atmosphere'), nl, write('To the east is the kitchen'), nl, write('To the south is the study'), nl.
describe(kitchen) :- write('You are in the kitchen, cabinets line the walls, and the floors are covered in cream coloured tile... the light fixtures seem to have been ripped out of the ceiling...'), nl, write('To the west is the living room'), nl, write('To the north is the back door'), nl, write('To the south is the dining room'),nl.
describe(well) :- write('You approach a plot of land with a deep well in the middle, as you stare into the depths, the wind whistles by...'), nl, write('To the west is the back door'), nl.
describe(back_door) :- write('You stand outside at the back door of the house, the rain is still pouring, and the wind is picking up...'), nl, write('To the north is the shed'), nl, write('To the east is the well'), nl, write('To the south is the kitchen'),nl.
describe(bedroom) :- write('You are in the bedroom, the air is still, and no light can get through the boarded up windows... you feel like you are close to something, but you do not know what...'), nl, write('To the west is the upstairs hallway'), nl, write('To the north is the bedroom closet'), nl.
describe(cellar) :- write('You are in the cellar, it is dark, and musty... The air is moist and you can hear water dripping from somewhere'), nl, write('To go back to the stairs, enter u.'), nl.
describe(shed) :- write('You are in the shed... As the wind howls outside, the thin walls seem to shake...'), nl, write('to the south is the back door'), nl.
describe(bathroom) :- write('You enter the bathroom... the fixtures are outdated, and there does not seem to be any access to water...'), nl, write('To the south is the upstairs hallway'), nl.
describe(bedroom_closet) :- write('You are in the bedroom closet... again, the light fixtures seem to have been ripped from the ceiling...surprisingly, there are clothes and boxes lined up on the north wall, almost as if they are blocking something...'), nl, write('To the south is the bedroom'), nl.
describe(closet) :- write('You enter the upstairs closet, light pours in from behind you... it is mostly empty inside here...'), nl, write('To the east is the upstairs hallway'), nl.
describe(secret_room) :- write('You have entered a secret room... anxiety pours over you... maybe you should make this quick in case someone is trying to find you...'), nl, write('To the south is the bedroom closet'),nl.


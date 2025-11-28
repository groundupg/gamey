# Stream of Consciousness

This file is a *stream of consciousness* -- entries may take the appearance of documentation, planning,
thinking; however, the purpose of this file is discovery.

## 28.11.25

After receiving a copy of the raw *chase in space* program, and attempting to make changes, I
am becoming aware of my lack of knowledge of the procedures within the game.

What I originally homed in on was the `Entity` struct, and related functions. My thinking was
that the `Entity` struct could be separated into the 3 types of entities defined in the
enum for `entities.type`. Regarding the functionality -- which appeared as conditionals that would
switch on `entity.type` -- these could all be replaced by unique functions to the specific
entity.
This started off well. The `case` statements within the `switch` statements were replaced by
unique functions. Issues occured, however, when I looked to remove the `Entity` struct and
replace every bit of functionality which used it with functionality related to the specific
entity the functionality was related to.
The program ran, yes, but it was extremely slow -- entities were moving on the movement of my mouse
while keyboard actions resulted in snail-paced movements.

It was at this moment I became viscerally aware of the fact that I had no idea what the program
was actually doing. I didn't change the tick rate stuff, did I??
I, being unaware of what actually happens on the execution of this program, found myself
making small tweaks, and re-running the program to see if the change worked; I even found myself
prompting what the cause may be on ChatGPT!

When has understanding ever been gained through such means....

I would now care to understand how this program works.
More generally, I would like to understand how the main event loop of a game works


/* Authors:
* Daqi Lin
* Ghesn Sfeir
* David Quesada
*/

/* Song recommendation:
* 1 - Songs are recommended blindly at first.
* 2 - Songs can be liked, trashed, or passed.
* 3 - Likes increments the score of the labels up in 1 point, trash discards those labels permanently and pass simply calls another song
* 4 - There is no stopping point as of now, probably the end will be when no more songs are available.
*/


/*Songs format*/
/* song(name, genre, language, group). */

/*Labels format*/
/* label(name, points). */

:- dynamic label/2.

label("rock", 0).
label("ska", 0).
label("house", 0).

label("Spanish", 0).
label("English", 0).
label("none", 0).

label("ACDC", 0).
label("La Pegatina", 0).

valid_song(Name, G,L,Gr) :- song(Name,G,L,Gr), label(G,_), label(L,_), label(Gr,_).
song("Back in black", "rock", "English", "ACDC").
song("Tomasin", "ska", "Spanish", "La Pegatina").

ask_input(Labels) :-
	repeat,
	read(Option),
	(Option == 1 ->  !, nl, increase_score(Labels);
	Option == 2 -> !, nl, delete_labels(Labels);
	Option == 3 -> !, nl;
	write("Invalid option.") -> nl, fail).

increase_score([]).
increase_score([Label|Rest]) :-
	label(Label, N),
	retract(label(Label,N)),
	assert(label(Label, N+1)),
	increase_score(Rest).
	
delete_labels([]).
delete_labels([Label|Rest]) :-
	label(Label, N),
	retract(label(Label,N)),
	delete_labels(Rest).
	
	

main() :-
	repeat,
	valid_song(Name, G, L, Gr),
	write("Now playing: "), write(Name), write(", by "), write(Gr), nl,
	write("1 - Like"), nl,
	write("2 - Trash"), nl,
	write("3 - Pass"), nl,
	
	ask_input([G,L,Gr]),
	fail.

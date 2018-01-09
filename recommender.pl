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
:- dynamic song/4.

valid_song(Name, G,L,Gr) :- song(Name,G,L,Gr), label(G,_), label(L,_), label(Gr,_).

ask_input(Labels, SongName) :-
	repeat,
	read(Option),
	(Option == 1 ->  !, nl, increase_score(Labels), delete_song(SongName);
	Option == 2 -> !, nl, decrease_score(Labels), delete_song(SongName);
	Option == 3 -> !, nl;
	write("Invalid option.") -> nl, fail).

increase_score([]).
increase_score([Label|Rest]) :-
	label(Label, N),
	retract(label(Label,N)),
	assert(label(Label, N+1)),
	increase_score(Rest).
	
decrease_score([]).
decrease_score([Label|Rest]) :-
	label(Label, N),
	retract(label(Label,N)),
    assert(label(Label, N-1)),
	decrease_score(Rest).

delete_song(SongName) :- retract(song(SongName,_,_,_)).
	
	
display_song(SongName, SongGroup, SongGender, SongScore):-
    write("Now playing: "),
    write(SongName),
    write(", by "),
    write(SongGroup),
    write(" ("),
    write(SongGender),
    write("). Score: "),
    write(SongScore),
    nl.

display_options():-
	write("1 - Like"), nl,
	write("2 - Trash"), nl,
	write("3 - Pass"), nl.

get_max([X],X).
get_max([X,Y|T],MAX) :- X>Y, get_max([X|T],MAX).
get_max([X,Y|T],MAX) :- X=<Y, get_max([Y|T],MAX).

get_max_score(MaxScore):-
    findall(Score, (song(_, Gender, Language, Group), calculate_score(Gender, Language, Group, Score)), Scores),
    get_max(Scores, MaxScore).

calculate_score(Gender, Language, Group, Score):-
    label(Gender, GenderScore),
    label(Language, LanguageScore),
    label(Group, GroupScore),
    Score is GenderScore + LanguageScore + GroupScore.

fetch_recommended_song(SongName, SongGender, SongLanguage, SongGroup, SongScore):-
    get_max_score(MaxScore),
    MinScore is (MaxScore * 2) / 3,
    findall(
        (Song, Gender, Language, Group, Score),
        (song(Song, Gender, Language, Group), calculate_score(Gender, Language, Group, Score), Score >= MinScore),
        Songlist),
    length(Songlist, Length),
    random(0, Length, Index),
    nth0(Index, Songlist, (SongName, SongGender, SongLanguage, SongGroup, SongScore)).

main() :-
	repeat,
    
    fetch_recommended_song(SongName, SongGender, SongLanguage, SongGroup, SongScore),
    display_song(SongName, SongGroup, SongGender, SongScore),
    display_options(),
	
	ask_input([SongGender, SongLanguage, SongGroup], SongName),
	fail.

:-module(botlogic, [tilesamount/2, mosttiles/2]).
:-use_module(game).
:-use_module(rules).

botact(Action):-
  board([A,B,C,D,E,F,G]),

mosttiles([], 0).
mosttiles([H|T], Res):-
 mosttiles(T, Res), tilesamount(H, Most), print(H), Res > Most.
mostttiles([_|T], Most):-
  mosttiles(T, Most).

tilesamount([], 0).
tilesamount([o|T], NewAmount):-
  !, tilesamount(T, Amount), NewAmount is Amount + 1.
tilesamount([x|T], NewAmount):-
  !, tilesamount(T, Amount), NewAmount is Amount + 1.
tilesamount([_|T], Amount):-
  tilesamount(T, Amount).

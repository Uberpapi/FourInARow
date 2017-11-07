:-module(botlogic, [tilesamount/2, mosttiles/2]).
:-use_module(game).
:-use_module(rules).

weight(d, 1).
weight(c, 2). weight(e, 2).
weight(f, 3). weight(b, 3).
weight(a, 4). weight(g, 4).

botact(Action):-
  board(Q),
  analyse(Q, Decision),
  call(Decision).

analyse(Q, Decision):-
  checkRow(Q, Z),
analyse(Q, Decision):-
  tMatrix(Q, M),
  checkRow(M, Z),
analyse(Q, Decision):-
  checkRow(Q, Z),

checkYRow([], []).
checkYRow([[A,B,C|[]]|Rest], Decisions):-
  !, checkYRow(Rest, Decisions).
checkYRow([[A,B,C,D|T]|Rest], [[What,Value]|Decisions]]):-
  notBoth([A,B,C,D], Value, What), !,
  checkYRow([[B,C,D|T]|Rest], Decisions).
checkYRow([[_|T]|Rest], Decisions):-
  checkYRow([T|Rest], Decisions).

notBoth(Q, Value, What):-
  notBoth(Q, [], Value, What).



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

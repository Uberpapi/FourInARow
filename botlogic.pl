:-module(botlogic, [tilesamount/2, mosttiles/2, notBoth/2, checkYRow/3, sortDecision/2]).
:-use_module(game).
:-use_module(rules).

value(a,1). value(b,2). value(c,3).
value(d,4). value(e,5). value(f,6). value(g,7).

weight(d, 1).
weight(c, 2). weight(e, 2).
weight(f, 3). weight(b, 3).
weight(a, 4). weight(g, 4).

botact(Action):-
  board(Q),
  analyse(Q, Decision),
  call(Decision).

analyse(Q, Decision):-
  checkRow(Q, Z).
analyse(Q, Decision):-
  tMatrix(Q, M),
  checkRow(M, Z).
analyse(Q, Decision):-
  checkRow(Q, Z).

sortDecision(Q, Decision):-
  sortDecision(Q, [], Decision).

sortDecision([], [C,D], C).
sortDecision([[A,B]|Rest], [], Decision):-
  !, value(X, A),
  sortDecision(Rest, [X, B], Decision).
sortDecision([[A,B]|Rest], [C,D], Decision):-
  B == D,
  value(X, A),
  weight(X, Y),
  weight(C, K),
  Y < K,
  !, sortDecision(Rest, [X, B], Decision).
sortDecision([[A,B]|Rest], [C,D], Decision):-
  B > D,
  !, value(X, A),
  sortDecision(Rest, [X, B], Decision).
sortDecision([_|Rest], [C,D], Decision):-
  sortDecision(Rest, [C,D], Decision).



checkYRow([], [], _).
checkYRow([[A,B,C|[]]|Rest], Decisions, ColNr):-
  !, NewColNr is ColNr + 1,
  checkYRow(Rest, Decisions, NewColNr).
checkYRow([[A,B,C,D|T]|Rest], [[ColNr,Value]|Decisions], ColNr):-
  notBoth([A,B,C,D], Value), !,
  checkYRow([[B,C,D|T]|Rest], Decisions, ColNr).
checkYRow([[_|T]|Rest], Decisions, ColNr):-
  checkYRow([T|Rest], Decisions, ColNr).

notBoth(Q, Value):-
  notBoth(Q, 0, Value).
notBoth([], Value, Value).
notBoth([o|T], Value, R):-
!,  NewValue is Value + 1,
  notBoth(T, NewValue, R).
notBoth([x|T], Value, R):-
!,  fail.
notBoth([_|T], Value, R):-
  notBoth(T, Value, R).

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

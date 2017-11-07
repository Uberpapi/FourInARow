:-module(botlogic, [analyse/2, checkYRow/3, checkXRow/4, evaluate/3,
                    botact/0, sortYDecision/2]).
:-use_module(game).
:-use_module(rules).

/*Database for our columns */
value(a, 1). value(b, 2). value(c, 3).
value(d, 4). value(e, 5). value(f, 6). value(g, 7).

weight(d, 1).               % Because middle is best
weight(c, 2). weight(e, 2).
weight(f, 3). weight(b, 3).
weight(a, 4). weight(g, 4). % Because edges are worst

botact:-
  createBoard(6, Q),
  findall(Decision, analyse(Q, Decision), Decisions),
  print(Decisions).
  %call(Decision).

analyse(Q, Decision):-
  checkYRow(Q, Z, 1),
  sortYDecision(Z, Decision).
analyse(Q, Decision):-
  tMatrix(Q, M),
  checkXRow(M, Z, 1, 6),
  sortXDecision(Q, Z, Decision).
%analyse(Q, Decision):-
%  checkRow(Q, Z).

sortYDecision(Q, Decision):-
  sortYDecision(Q, [], Decision).

sortYDecision([], [C,D], [C,D]).
sortYDecision([[A,B]|Rest], [], Decision):-
  !, value(X, A),
  sortYDecision(Rest, [X, B], Decision).
sortYDecision([[A,B]|Rest], [C,D], Decision):-
  B == D,
  value(X, A),
  weight(X, Y),
  weight(C, K),
  Y < K,
  !, sortYDecision(Rest, [X, B], Decision).
sortYDecision([[A,B]|Rest], [C,D], Decision):-
  B > D,
  !, value(X, A),
  sortYDecision(Rest, [X, B], Decision).
sortYDecision([_|Rest], [C,D], Decision):-
  sortYDecision(Rest, [C,D], Decision).

sortXDecision(Q, Decisions, Decision):-
  sortXDecision(Q, Decisions, [], Decision).

sortXDecision(_, [], Decision, Decision):- !.
sortXDecision(Q, [[Value, RowNr, List]|Decisions], [], Decision):- %Saving our first decision if we have no previous
  !, evaluate(Q, RowNr, List, [Col, LengthToRow]),
  sortXDecision(Q, Decisions, [Value, Col, LengthToRow], Decision).
sortXDecision(Q, [[Value, RowNr, List]|Decisions], [A, _, _], Decision):- %1st we prioritize Value
  evaluate(Q, RowNr, List, [Col, LengthToRow]),
  A < Value, !,
  sortXDecision(Q, Decisions, [Value, Col, LengthToRow], Decision).
sortXDecision(Q, [[Value, RowNr, List]|Decisions], [_, _, A], Decision):- %2nd we prioritize the shortest length we have
  evaluate(Q, RowNr, List, [Col, LengthToRow]),                          %left to the row we have the highest Value at
  LengthToRow < A, !,
  sortXDecision(Q, Decisions, [Value, Col, LengthToRow], Decision).
sortXDecision(Q, [[Value, RowNr, List]|Decisions], [_, A, _], Decision):- %3rd we prioritize middle placement
  evaluate(Q, RowNr, List, [Col, LengthToRow]),
  weight(Col, X), weight(A, Y),
  Y > X, !,
  sortXDecision(Q, Decisions, [Value, Col, LengthToRow], Decision).
sortXDecision(Q, [_|Decisions], [A, B, C], Decision):- %Satisfies rest of the cases
  sortXDecision(Q, Decisions, [A, B, C], Decision).

evaluate(Q, RowNr, List, Col):-
  evaluate(Q, RowNr, List, [], Col).

evaluate(_, _, [], Col, Col).
evaluate(Q, RowNr, [A|B], [], Col):-
  value(A, X),
  getRow(Q, X, Row),
  tilesamount(Row, L),
  LengthToRow is RowNr - L,
  evaluate(Q, RowNr, B, [A,LengthToRow], Col).
evaluate(Q, RowNr, [A|B], [C,L], Col):-
  value(A, X),
  getRow(Q, X, Row),
  tilesamount(Row, K),
  LengthToRow is RowNr - K,
  LengthToRow < L, !,
  evaluate(Q, RowNr, B, [A,LengthToRow], Col).
evaluate(Q, RowNr, [_|B], [C,L], Col):-
  evaluate(Q, RowNr, B, [C,L], Col).


checkYRow([], [], _).
checkYRow([[A,B,C|[]]|Rest], Decisions, ColNr):-
  !, NewColNr is ColNr + 1,
  checkYRow(Rest, Decisions, NewColNr).
checkYRow([[A,B,C,D|T]|Rest], [[ColNr,Value]|Decisions], ColNr):-
  notYBoth([A,B,C,D], Value), !,
  checkYRow([[B,C,D|T]|Rest], Decisions, ColNr).
checkYRow([[_|T]|Rest], Decisions, ColNr):-
  checkYRow([T|Rest], Decisions, ColNr).

checkXRow([], [], _, _).
checkXRow([[A,B,C|[]]|Rest], Decisions, ColNr, RowNr):-
  NewRowNr is RowNr - 1,
  checkXRow(Rest, Decisions, 1, NewRowNr).
checkXRow([[A,B,C,D|T]|Rest], [[Value, RowNr, Result]|Decisions], ColNr, RowNr):-
  NewColNr is ColNr + 1,
  notXBoth([A,B,C,D], Value, List), !,
  positionList(List, ColNr, PosList),
  reverseList(PosList, Result),
  checkXRow([[B,C,D|T]|Rest], Decisions, NewColNr, RowNr).
checkXRow([[_|T]|Rest], Decisions, ColNr, RowNr):-
  NewColNr is ColNr + 1,
  checkXRow([T|Rest], Decisions, NewColNr, RowNr).

notYBoth(Q, Value):-
  notYBoth(Q, 0, Value).
notYBoth([], Value, Value).
notYBoth([o|T], Value, R):-
!,  NewValue is Value + 1,
  notYBoth(T, NewValue, R).
notYBoth([x|T], _, _):-
!,  fail.
notYBoth([_|T], Value, R):-
  notYBoth(T, Value, R).

notXBoth(Q, Value, List):-
  notXBoth(Q, 0, Value, [], List, 0).

notXBoth([], Value, Value, List, List, _).
notXBoth([o|T], Value, R, List, L, Count):-
  !, NewValue is Value + 1,
  NewCount is Count + 1,
  notXBoth(T, NewValue, R, List, L, NewCount).
notXBoth([x|T], _, _, _, _, _):-
  !,  fail.
notXBoth([_|T], Value, R, List, L, Count):-
  NewCount is Count + 1,
  notXBoth(T, Value, R, [Count|List], L, NewCount).

/* Adds colNr to each element in List */
positionList([], _, []).
positionList([H|T], ColNr, [X|L]):-
 Res is H + ColNr,
 value(X, Res),
 positionList(T, ColNr, L).

tilesamount([], 0).
tilesamount([o|T], NewAmount):-
  !, tilesamount(T, Amount), NewAmount is Amount + 1.
tilesamount([x|T], NewAmount):-
  !, tilesamount(T, Amount), NewAmount is Amount + 1.
tilesamount([_|T], Amount):-
  tilesamount(T, Amount).

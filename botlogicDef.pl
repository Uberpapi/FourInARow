module(botlogicDef, []).
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
analyse(Q, Decision):-
 checkDRow(Q, Z, 1, 1),
 sortDDecision(Q, Z, Decision).

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
sortYDecision([[A,B]|Rest], [_,D], Decision):-
  B > D,
  !, value(X, A),
  sortYDecision(Rest, [X, B], Decision).
sortYDecision([_|Rest], [C,D], Decision):-
  sortYDecision(Rest, [C,D], Decision).

sortXDecision(Q, Decisions, Decision):-
  sortXDecision(Q, Decisions, [], Decision).

sortXDecision(_, [], Decision, Decision):- !.
sortXDecision(Q, [[Value, RowNr, List]|Decisions], [], Decision):- %Saving our first decision if we have no previous
  !, evaluateX(Q, RowNr, List, [Col, LengthToRow]),
  sortXDecision(Q, Decisions, [Value, Col, LengthToRow], Decision).
sortXDecision(Q, [[Value, RowNr, List]|Decisions], [A, _, _], Decision):- %1st we prioritize Value
  A < Value, !,
  evaluateX(Q, RowNr, List, [Col, LengthToRow]),
  sortXDecision(Q, Decisions, [Value, Col, LengthToRow], Decision).
sortXDecision(Q, [[Value, RowNr, List]|Decisions], [_, _, A], Decision):- %2nd we prioritize the shortest length we have
  evaluateX(Q, RowNr, List, [Col, LengthToRow]),                          %left to the row we have the highest Value at
  LengthToRow < A, !,
  sortXDecision(Q, Decisions, [Value, Col, LengthToRow], Decision).
sortXDecision(Q, [[Value, RowNr, List]|Decisions], [_, A, _], Decision):- %3rd we prioritize middle placement
  evaluateX(Q, RowNr, List, [Col, LengthToRow]),
  weight(Col, X), weight(A, Y),
  Y > X, !,
  sortXDecision(Q, Decisions, [Value, Col, LengthToRow], Decision).
sortXDecision(Q, [_|Decisions], [A, B, C], Decision):- %Satisfies rest of the cases
  sortXDecision(Q, Decisions, [A, B, C], Decision).

sortDDecision(Q, Decisions, Decision):-
  sortDDecision(Q, Decisions, [], Decision).

sortDDecision(_, [], Decision, Decision):- !.
sortDDecision(Q, [[Value, List]|Decisions], [], Decision):- %Saving our first decision if we have no previous
  !, evaluateD(Q, List, [Col, LengthToRow]),
  sortDDecision(Q, Decisions, [Value, Col, LengthToRow], Decision). %1st we prioritize Value
sortDDecision(Q, [[Value, List]|Decisions], [A,_,_], Decision):-
  A < Value, !,
  evaluateD(Q, List, [Col, LengthToRow]),
  sortXDecision(Q, Decisions, [Value, Col, LengthToRow], Decision). %2nd we prioritize the shortest length we have
sortDDecision(Q, [[Value, List]|Decisions], [_, _, A], Decision):-  %left to the row we have the highest Value at
  evaluateD(Q, List, [Col, LengthToRow]),
  LengthToRow < A, !,
  sortDDecision(Q, Decisions, [Value, Col, LengthToRow], Decision).
sortDDecision(Q, [[Value, List]|Decisions], [_, A, _], Decision):- %3rd we prioritize middle placement
  evaluateD(Q, List, [Col, LengthToRow]),
  weight(Col, X), weight(A, Y),
  Y > X, !,
  sortDDecision(Q, Decisions, [Value, Col, LengthToRow], Decision).
sortDDecision(Q, [[_, _]|Decisions], [A, B, C], Decision):- %Satisfies rest of the cases
  sortDDecision(Q, Decisions, [A, B, C], Decision).

checkYRow([], [], _).
checkYRow([[_,_,_|[]]|Rest], Decisions, ColNr):-
  !, NewColNr is ColNr + 1,
  checkYRow(Rest, Decisions, NewColNr).
checkYRow([[A,B,C,D|T]|Rest], [[Value, ColNr]|Decisions], ColNr):-
  notYBoth([A,B,C,D], Value), !,
  checkYRow([[B,C,D|T]|Rest], Decisions, ColNr).
checkYRow([[_|T]|Rest], Decisions, ColNr):-
  checkYRow([T|Rest], Decisions, ColNr).

checkXRow([], [], _, _).
checkXRow([[_,_,_|[]]|Rest], Decisions, _, RowNr):-
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

checkDRow([], [], _, _):- !.
checkDRow([_|Rest], Decisions, 7, ColNr):-
  !, NewColNr is ColNr + 1,
  checkDRow(Rest, Decisions, 1, NewColNr).
checkDRow(Q, [[Value, Result]|Decisions], RowNr, ColNr):-
  RowNr < 4,
  countUp(Q, RowNr, [Value, Result], ColNr, 1), !,
  NewRowNr is RowNr + 1,
  checkDRow(Q, Decisions, NewRowNr, ColNr).
checkDRow(Q, [[Value, Result]|Decisions], RowNr, ColNr):-
  RowNr > 3,
  countDown(Q, RowNr, [Value, Result], ColNr, 1), !,
  NewRowNr is RowNr + 1,
  checkDRow(Q, Decisions, NewRowNr, ColNr).
checkDRow(Q, Decisions, RowNr,  ColNr):-
  NewRowNr is RowNr + 1,
  checkDRow(Q, Decisions, NewRowNr, ColNr).

countDown(_, _, [0, []], _, 5).
countDown([H|T], RowNr, [NewCount, Col], ColNr, Nr):-
  NewRowNr is RowNr - 1,
  getElement(H, RowNr, x), !,
  NewNr is Nr + 1,
  NewColNr is ColNr + 1,
  countDown(T, NewRowNr, [Count, Col], NewColNr, NewNr),
  NewCount is Count + 1.
countDown([H|T], RowNr, [Count, [[NewCol, RowRevNr]|Col]], ColNr, Nr):-
  NewRowNr is RowNr - 1,
  getElement(H, RowNr, X),
  X \== o, !,
  value(NewCol, ColNr),
  RowRevNr is 7 - RowNr,
  NewNr is Nr + 1,
  NewColNr is ColNr + 1,
  countDown(T, NewRowNr, [Count, Col], NewColNr, NewNr).
countDown(_, _, _, _, _):-
  fail.

/* Checking diagonally upwards */
countUp(_, _, [0, []], _, 5).
countUp([H|T], RowNr, [NewCount, Col], ColNr, Nr):-
  getElement(H, RowNr, x), !,
  NewRowNr is RowNr + 1,
  NewNr is Nr + 1,
  NewColNr is ColNr + 1,
  countUp(T, NewRowNr, [Count, Col], NewColNr, NewNr),
  NewCount is Count + 1.
countUp([H|T], RowNr, [Count, [[NewCol, RowRevNr]|Col]], ColNr, Nr):-
  NewRowNr is RowNr + 1,
  getElement(H, RowNr, X),
  X \== o, !,
  RowRevNr is 7 - RowNr,
  value(NewCol, ColNr),
  NewNr is Nr + 1,
  NewColNr is ColNr + 1,
  countUp(T, NewRowNr, [Count, Col], NewColNr, NewNr).
countUp(_, _, _, _, _):-
  fail.

notYBoth(Q, Value):-
  notYBoth(Q, 0, Value).
notYBoth([], Value, Value).
notYBoth([x|T], Value, R):-
!,  NewValue is Value + 1,
  notYBoth(T, NewValue, R).
notYBoth([o|_], _, _):-
!,  fail.
notYBoth([_|T], Value, R):-
  notYBoth(T, Value, R).

notXBoth(Q, Value, List):-
  notXBoth(Q, 0, Value, [], List, 0).

notXBoth([], Value, Value, List, List, _).
notXBoth([x|T], Value, R, List, L, Count):-
  !, NewValue is Value + 1,
  NewCount is Count + 1,
  notXBoth(T, NewValue, R, List, L, NewCount).
notXBoth([o|_], _, _, _, _, _):-
  !,  fail.
notXBoth([_|T], Value, R, List, L, Count):-
  NewCount is Count + 1,
  notXBoth(T, Value, R, [Count|List], L, NewCount).

evaluateX(Q, RowNr, List, Col):-
  evaluateX(Q, RowNr, List, [], Col).

evaluateX(_, _, [], Col, Col).
evaluateX(Q, RowNr, [A|B], [], Col):-
  value(A, X),
  getRow(Q, X, Row),
  tilesamount(Row, L),
  LengthToRow is RowNr - L,
  evaluateX(Q, RowNr, B, [A,LengthToRow], Col).
evaluateX(Q, RowNr, [A|B], [_,L], Col):-
  value(A, X),
  getRow(Q, X, Row),
  tilesamount(Row, K),
  LengthToRow is RowNr - K,
  LengthToRow < L, !,
  evaluateX(Q, RowNr, B, [A,LengthToRow], Col).
evaluateX(Q, RowNr, [_|B], [C,L], Col):-
  evaluateX(Q, RowNr, B, [C,L], Col).

evaluateD(Q, List, Col):-
  evaluateD(Q, List, [], Col).

evaluateD(_, [], Col, Col):- !.
evaluateD(Q, [[A,RowNr]|B], [], Col):-
  !, value(A, X),
  getRow(Q, X, Row),
  tilesamount(Row, L),
  LengthToRow is RowNr - L, %Since our Row number is counted reversed
  evaluateD(Q, B, [A,LengthToRow], Col).
evaluateD(Q, [[A,RowNr]|B], [_,L], Col):-
  value(A, X),
  getRow(Q, X, Row),
  tilesamount(Row, K),
  LengthToRow is RowNr - K, %Since our Row number is counted reversed
  LengthToRow < L, !,
  evaluateD(Q, B, [A,LengthToRow], Col).
evaluateD(Q, [_|B], [C,L], Col):-
  evaluateD(Q, B, [C,L], Col).

/* Adds colNr to each element in List */
positionList([], _, []).
positionList([H|T], ColNr, [X|L]):-
 Res is H + ColNr,
 value(X, Res),
 positionList(T, ColNr, L).

tilesamount([], 1).
tilesamount([x|T], NewAmount):-
  !, tilesamount(T, Amount), NewAmount is Amount + 1.
tilesamount([o|T], NewAmount):-
  !, tilesamount(T, Amount), NewAmount is Amount + 1.
tilesamount([_|T], Amount):-
  tilesamount(T, Amount).

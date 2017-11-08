:-module(botlogic, [analyse/2, checkYRow/3, checkXRow/4, evaluateX/3,
                    maya/1]).
:-use_module(game).
:-use_module(rules).

/*Database for our columns */
value(a, 1). value(b, 2). value(c, 3).
value(d, 4). value(e, 5). value(f, 6). value(g, 7).

weight(d, 1).               % Because middle is best
weight(c, 2). weight(e, 2).
weight(f, 3). weight(b, 3).
weight(a, 4). weight(g, 4). % Because edges are worst

maya(Act):-
  board(Q),
  oBecomesx(Q, M),
  findall(Decision, analyse(Q, Decision), OffDecisions),print('Offensive decisions is '), print(OffDecisions), nl, %Offensive decisions
  findall(Decision, analyse(M, Decision), DefDecisions),print('Defensive decisions is '), print(DefDecisions), nl, %Defensive decisions
  whatToDoOffense(OffDecisions, ActOff), print('Offensive decision is '), print(ActOff), nl,
  whatToDoDefense(DefDecisions, ActDef), print('Defensive decision is '), print(ActDef), nl,
  offOrDef(ActOff, ActDef, [DeforOff, Act]),
  print(' bot puts in '), print(DeforOff), print(' '), print(Act), nl.

offOrDef([ValueOff, ColOff, LengthToRowOff], [ValueDef, ColDef, LengthToRowDef], [offensive, ColOff]):-
  ValueOff == 3,
  LengthToRowOff == 0, !.
offOrDef([_, _, _], [ValueDef, ColDef, LengthToRowDef], [defensive, ColDef]):-
  ValueDef > 1,
  LengthToRowDef == 0, !.
offOrDef([ValueOff, ColOff, LengthToRowOff], [ValueDef, ColDef, LengthToRowDef],[defensive, ColDef]):-
  ValueOff < ValueDef,
  (LengthToRowDef == 0 ; LengthToRowDef == 2), !.
offOrDef([ValueOff, _, _], [ValueDef, ColDef, LengthToRowDef], [defensive, ColDef]):-
  ValueDef > 0,
  ValueOff == ValueDef,
  LengthToRowDef == 0, !.
offOrDef([_, ColOff, _],[_, _, _], [offensive, ColOff]).

whatToDoOffense([], [0, f, 0]).
whatToDoOffense(OffDecisions, Act):-
  whatToDoOffense(OffDecisions, [], Act).
whatToDoOffense([], Act, Act).
whatToDoOffense([[Count, Col, LengthToRow]|Rest], [], Act):-
  whatToDoOffense(Rest, [Count, Col, LengthToRow], Act).
whatToDoOffense([[Count, Col, LengthToRow]|Rest], [A, _, _], Act):-
  A < Count, !,
  whatToDoOffense(Rest, [Count, Col, LengthToRow], Act).
whatToDoOffense([[Count, Col, LengthToRow]|Rest], [A, _, B], Act):-
  Count == A,
  LengthToRow < B, !,
  whatToDoOffense(Rest, [Count, Col, LengthToRow], Act).
whatToDoOffense([[Count, Col, LengthToRow]|Rest], [A, B, C], Act):-
  A == Count,
  LengthToRow == C,
  weight(B, X), weight(Col, Y),
  Y < X, !,
  whatToDoOffense(Rest, [Count, Col, LengthToRow], Act).
whatToDoOffense([_|Rest], [A, B, C], Act):-
  whatToDoOffense(Rest, [A, B, C], Act).

whatToDoDefense([], [0, a, 0]).
whatToDoDefense(DefDecisions, Act):-
  whatToDoDefense(DefDecisions, [], Act).
whatToDoDefense([], Act, Act).
whatToDoDefense([[Count, Col, LengthToRow]|Rest], [], Act):-
  whatToDoDefense(Rest, [Count, Col, LengthToRow], Act).
whatToDoDefense([[Count, Col, LengthToRow]|Rest], [A, _, _], Act):-
  Count > A,
  whatToDoDefense(Rest, [Count, Col, LengthToRow], Act).
whatToDoDefense([[Count, Col, LengthToRow]|Rest], [A, _, B], Act):-
  A == Count,
  LengthToRow < B,
  whatToDoDefense(Rest, [Count, Col, LengthToRow], Act).
whatToDoDefense([[Count, Col, LengthToRow]|Rest], [A, B, C], Act):-
  A == Count,
  LengthToRow == C,
  weight(B, X), weight(Col, Y),
  Y < X,
  whatToDoDefense(Rest, [Count, Col, LengthToRow], Act).
whatToDoDefense([_|Rest], [A, B, C], Act):-
  whatToDoDefense(Rest, [A, B, C], Act).


/*Swaps all o to x and vice versa*/
oBecomesx([], []).
oBecomesx([H|T], [L|Res]):-
  oBecomesx(T, Res), swapOforX(H, L).

swapOforX([], []).
swapOforX([o|T], [x|Res]):-
  !, swapOforX(T, Res).
swapOforX([x|T], [o|Res]):-
  !, swapOforX(T, Res).
swapOforX([H|T], [H|Res]):-
  swapOforX(T, Res).

/*Returns one decision based on the board Vertically,
  one Horisontally and one Diagonally                */
analyse(Q, [A, B, 0]):-
  checkYRow(Q, Z, 1),
  sortYDecision(Z, [A, B]).
analyse(Q, Decision):-
  tMatrix(Q, M),
  checkXRow(M, Z, 1, 6),
  sortXDecision(Q, Z, Decision).
analyse(Q, Decision):-
 checkDRow(Q, Z, 1, 1),
 sortDDecision(Q, Z, Decision).

sortYDecision(Q, Decision):-
  sortYDecision(Q, [], Decision).

sortYDecision([], [C,D], [D,C]).
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
sortXDecision(Q, [[Value, RowNr, List]|Decisions], [A, _, B], Decision):- %2nd we prioritize the shortest length we have
  evaluateX(Q, RowNr, List, [Col, LengthToRow]),
  A == Value,
  LengthToRow < B, !,
  sortXDecision(Q, Decisions, [Value, Col, LengthToRow], Decision).
sortXDecision(Q, [[Value, RowNr, List]|Decisions], [A, B, C], Decision):- %3rd we prioritize middle placement
  evaluateX(Q, RowNr, List, [Col, LengthToRow]),
  weight(Col, X), weight(B, Y),
  A == Value,
  LengthToRow == B,
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
sortDDecision(Q, [[Value, List]|Decisions], [A, _, B], Decision):-  %left to the row we have the highest Value at
  evaluateD(Q, List, [Col, LengthToRow]),
  A == Value,
  LengthToRow < B, !,
  sortDDecision(Q, Decisions, [Value, Col, LengthToRow], Decision).
sortDDecision(Q, [[Value, List]|Decisions], [A, B, C], Decision):- %3rd we prioritize middle placement
  evaluateD(Q, List, [Col, LengthToRow]),
  weight(Col, X), weight(B, Y),
  A == Value,
  LengthToRow == C,
  Y > X, !,
  sortDDecision(Q, Decisions, [Value, Col, LengthToRow], Decision).
sortDDecision(Q, [[_, _]|Decisions], [A, B, C], Decision):- %Satisfies rest of the cases
  sortDDecision(Q, Decisions, [A, B, C], Decision).

checkYRow([], [], _).
checkYRow([[_,_,_|[]]|Rest], Decisions, ColNr):-
  !, NewColNr is ColNr + 1,
  checkYRow(Rest, Decisions, NewColNr).
checkYRow([[A,B,C,D|T]|Rest], [[ColNr,Value]|Decisions], ColNr):-
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
  getElement(H, RowNr, o), !,
  NewNr is Nr + 1,
  NewColNr is ColNr + 1,
  countDown(T, NewRowNr, [Count, Col], NewColNr, NewNr),
  NewCount is Count + 1.
countDown([H|T], RowNr, [Count, [[NewCol, RowRevNr]|Col]], ColNr, Nr):-
  NewRowNr is RowNr - 1,
  getElement(H, RowNr, X),
  X \== x, !,
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
  getElement(H, RowNr, o), !,
  NewRowNr is RowNr + 1,
  NewNr is Nr + 1,
  NewColNr is ColNr + 1,
  countUp(T, NewRowNr, [Count, Col], NewColNr, NewNr),
  NewCount is Count + 1.
countUp([H|T], RowNr, [Count, [[NewCol, RowRevNr]|Col]], ColNr, Nr):-
  NewRowNr is RowNr + 1,
  getElement(H, RowNr, X),
  X \== x, !,
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
notYBoth([o|T], Value, R):-
!,  NewValue is Value + 1,
  notYBoth(T, NewValue, R).
notYBoth([x|_], _, _):-
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
notXBoth([x|_], _, _, _, _, _):-
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
  LengthToRow is RowNr - L,
  evaluateD(Q, B, [A,LengthToRow], Col).
evaluateD(Q, [[A,RowNr]|B], [_,L], Col):-
  value(A, X),
  getRow(Q, X, Row),
  tilesamount(Row, K),
  LengthToRow is RowNr - K,
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
tilesamount([o|T], NewAmount):-
  !, tilesamount(T, Amount), NewAmount is Amount + 1.
tilesamount([x|T], NewAmount):-
  !, tilesamount(T, Amount), NewAmount is Amount + 1.
tilesamount([_|T], Amount):-
  tilesamount(T, Amount).

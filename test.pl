

evaluate(Q, List, Col):-
  print(Q), nl,
  evaluate(Q, List, [], Col).
evaluate(_, [], Col, Col).
evaluate(Q, [A|B], [], Col):-
  value(A, X),
  getRow(Q, X, Row), print(Row), nl,
  tilesamount(Row, L),
  evaluate(Q, B, [A,L], Col).
evaluate(Q, [A|B], [C,L], Col):-
  value(A, X),
  getRow(Q, X, Row),
  tilesamount(Row, K),
  L < K, !,
  evaluate(Q, B, [A,K], Col).
evalute(Q, [_|B], [C,L], Col):-
  evaluate(Q, B, [C,L], Col).

:-module(play, [echo/0]).
:-use_module(game).
:-use_module(rules).
:-use_module(printboard).

echo:-
  write('>> '),
  read(X),
  call(X),
  echo.

play:-
  retractall(board(_)),
  createBoard(6, Q),
  setboard(Q),
  print.

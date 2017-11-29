:-module(play, [echo/0, initiate/0, place/3, element/3]).
:-use_module(game).
:-use_module(rules).
:-use_module(printboard).
:-use_module(botlogic).
<<<<<<< HEAD
:-use_module(randombot).
=======
:-use_module(gamelog).
>>>>>>> da44b12a464b1f02bd20510253646102f3eace53

player(p1, 'Player 1').
player(p2, 'Player 2').

initiate:-
  setplayerturn(p1),
  setwins([0,0]),
  start.

/*Infinite echo where we play */
echo:-
  playerturn(T),
<<<<<<< HEAD
  %write('>> '),
  ( T == p1 -> randomact(Actrandom), acceptedCommands(Actrandom), acttime(Actrandom), echo
  ; T == p1 -> print('That is not a valid command, try again mate.'), nl, echo
  ; maya(Act), acttime(Act), echo).
=======
  write('>> '),
  ( T == p1 -> read(X), acceptedCommands(X), writeToLog(' Player'), writeToLog(X), call(X), echo
  ; T == p1 -> print('That is not a valid command, try again mate.'), nl, echo
  ; maya(Act), writeToLog(' Maya'), writeToLog(Act), call(Act), echo).
>>>>>>> da44b12a464b1f02bd20510253646102f3eace53

/* Creates the board and starts the game */
start:-
  retractall(board(_)),
  %setplayerturn(p1),
  createBoard(6, Q),
  setboard(Q),
  setturns(0),
  print,
  print('             Welcome to our very decent game. '),nl,
  print('             Player 1 is Xs and Player 2 is Os.'),nl,
  print('Choose the column you wish to put your tile using the letters. '), nl,
  print('             Player 1 begins, Good Luck! :)'), nl.

/*Refreshes the board */
refresh:-
  retractall(board(_)),
  createBoard(6, Q),
  setboard(Q),
<<<<<<< HEAD
  setturns(0),
  wins([W1,W2]), print('Player has: '), print(W1), nl, print('Maya has: '), print(W2), nl.
=======
  setturns(0).

/*Initiates rematch*/
rematch:-
  refresh,
  print,
  playerturn(X),
  player(X, Turn),
  print(Turn),
  print(' begins this time! Column D might be a good spot to start...'), nl.

/* All the commands avalible for placing tiles */
a:-
  board(Q),
  place(Q, 1, M),
  playerturn(X),
  setboard(M),
  player(X, Turn),
  turns(Z),
  print,
  ( Z == 42 -> refresh, print('The board is full and it is a tie.... you are equally useless! Write rematch if you want another go.'), nl
  ; row(M), X == p1 -> refresh, writeToLog('Maya Wins'), writeToLog(nl), print('We have a Winner and that is Maya the bot!!!'), nl
  ; row(M), X == p2 -> refresh, writeToLog('Player Wins'), writeToLog(nl), print('We have a Winner and that is Player 1!!!'),  nl
  ;print(Turn), print(' next!'), nl).

b:-
  board(Q),
  place(Q, 2, M),
  playerturn(X),
  setboard(M),
  player(X, Turn),
  turns(Z),
  print,
  ( Z == 42 -> refresh, print('The board is full and it is a tie.... you are equally useless! Write rematch if you want another go.'), nl
  ; row(M), X == p1 -> refresh, writeToLog('Maya Wins'), writeToLog(nl), print('We have a Winner and that is Maya the bot!!!'), nl
  ; row(M), X == p2 -> refresh, writeToLog('Player Wins'), writeToLog(nl), print('We have a Winner and that is Player 1!!!'),  nl
  ;print(Turn), print(' next!'), nl).


c:-
  board(Q),
  place(Q, 3, M),
  playerturn(X),
  setboard(M),
  player(X, Turn),
  turns(Z),
  print,
  ( Z == 42 -> refresh, print('The board is full and it is a tie.... you are equally useless! Write rematch if you want another go.'), nl
  ; row(M), X == p1 -> refresh, writeToLog('Maya Wins'), writeToLog(nl), print('We have a Winner and that is Maya the bot!!!'), nl
  ; row(M), X == p2 -> refresh, writeToLog('Player Wins'), writeToLog(nl), print('We have a Winner and that is Player 1!!!'),  nl
  ;print(Turn), print(' next!'), nl).

d:-
  board(Q),
  place(Q, 4, M),
  playerturn(X),
  setboard(M),
  player(X, Turn),
  turns(Z),
  print,
  ( Z == 42 -> refresh, print('The board is full and it is a tie.... you are equally useless! Write rematch if you want another go.'), nl
  ; row(M), X == p1 -> refresh, writeToLog('Maya Wins'), writeToLog(nl), print('We have a Winner and that is Maya the bot!!!'), nl
  ; row(M), X == p2 -> refresh, writeToLog('Player Wins'), writeToLog(nl), print('We have a Winner and that is Player 1!!!'),  nl
  ;print(Turn), print(' next!'), nl).

e:-
  board(Q),
  place(Q, 5, M),
  playerturn(X),
  setboard(M),
  player(X, Turn),
  turns(Z),
  print,
  ( Z == 42 -> refresh, print('The board is full and it is a tie.... you are equally useless! Write rematch if you want another go.'), nl
  ; row(M), X == p1 -> refresh, writeToLog('Maya Wins'), writeToLog(nl), print('We have a Winner and that is Maya the bot!!!'), nl
  ; row(M), X == p2 -> refresh, writeToLog('Player Wins'), writeToLog(nl), print('We have a Winner and that is Player 1!!!'),  nl
  ;print(Turn), print(' next!'), nl).

f:-
  board(Q),
  place(Q, 6, M),
  playerturn(X),
  setboard(M),
  player(X, Turn),
  turns(Z),
  print,
  ( Z == 42 -> refresh, print('The board is full and it is a tie.... you are equally useless! Write rematch if you want another go.'), nl
  ; row(M), X == p1 -> refresh, writeToLog('Maya Wins'), writeToLog(nl), print('We have a Winner and that is Maya the bot!!!'), nl
  ; row(M), X == p2 -> refresh, writeToLog('Player Wins'), writeToLog(nl), print('We have a Winner and that is Player 1!!!'),  nl
  ;print(Turn), print(' next!'), nl).
>>>>>>> da44b12a464b1f02bd20510253646102f3eace53

acttime(Act):-
  value(Act, Col),
  board(Q),
  place(Q, Col, M),
  playerturn(X),
  setboard(M),
  player(X, Turn),
  turns(Z),
  wins([W1,W2]),
  %print,
  ( Z == 42 -> refresh, print('The board is full and it is a tie.... you are equally useless! Write rematch if you want another go.'), nl
<<<<<<< HEAD
  ; row(M), X == p1 -> refresh, W4 is W2 + 1, setwins([W1,W4]), print('We have a Winner and that is Maya the bot!!!'), nl
  ; row(M), X == p2 -> refresh, W3 is W1 + 1, setwins([W3,W2]), print('We have a Winner and that is Player 1!!!'),  nl
  ;nl). %print(Turn), print(' next!'), nl).
=======
  ; row(M), X == p1 -> refresh, writeToLog('Maya Wins'), writeToLog(nl), print('We have a Winner and that is Maya the bot!!!'), nl
  ; row(M), X == p2 -> refresh, writeToLog('Player Wins'), writeToLog(nl), print('We have a Winner and that is Player 1!!!'),  nl
  ;print(Turn), print(' next!'), nl).
>>>>>>> da44b12a464b1f02bd20510253646102f3eace53

/*All the accepted commands
  we can handle as inputs  */
acceptedCommands(X):-
  ( X == a -> true
  ; X == b -> true
  ; X == c -> true
  ; X == d -> true
  ; X == e -> true
  ; X == f -> true
  ; X == g -> true
  ; X == rematch -> true
  ; X == start -> true
  ; X == end_of_file  -> true
  ; X == maya -> true
  ; fail).

/*Initiates rematch*/
rematch:-
  refresh,
  %print,
  playerturn(X),
  player(X, Turn),
  print(Turn),
  print(' begins this time! Column D might be a good spot to start...'), nl.

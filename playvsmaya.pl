:-module(playvsmaya, [echo/0, initiate/0, place/3, element/3]).
:-use_module(game).
:-use_module(rules).
:-use_module(printboard).
:-use_module(botlogic).
:-use_module(randombot).
:-use_module(gamelog).
:-use_module(tcptest).
:-use_module(library(system)).

player(p1, 'Player 1').
player(p2, 'Player 2').

initiate:-
  initiateStream,
  setplayerturn(p1),
  setwins([0,0]),
  setsave([p1]),
  start.

/*Infinite echo where we play */
echo:-
  playerturn(T),
  write('>> '),
  ( T == p1 -> readStream([Move|_]), print(Move), value(Act, Move), print(Act), acttime(Act), nl
  ; T == p1 -> print('That is not a valid command, try again mate.'), nl
  ; maya(Act), acttime(Act), closeStream, initiateStream, board(U), parse(U, Res), sendStream(Res)),  !, echo.

/* Creates the board and starts the game */
start:-
  retractall(board(_)),
  setturns(0),
  createBoard(6, Q),
  setboard(Q),
  parse(Q, Res),
  sendStream(Res),
  %print,
  print('             Welcome to our very decent game. '),nl,
  print('             Player 1 is Xs and Player 2 is Os.'),nl,
  print('Choose the column you wish to put your tile using the letters. '), nl,
  print('             Player 1 begins, Good Luck! :)'), nl,
  %print,
  echo.

/*Refreshes the board */
refresh:-
  retractall(save(_)),
  playerturn(Turn),
  setsave([Turn]),
  retractall(board(_)),
  createBoard(6, Q),
  setboard(Q),
  setturns(0),
  wins([W1,W2]), print('RandomGruber has: '), print(W1), nl, print('Maya has: '), print(W2), nl.

acttime(Act):-
  value(Act, Col),
  board(Q),
  place(Q, Col, M),
  playerturn(X),
  setboard(M),
  player(X, Turn),
  turns(Z),
  wins([W1,W2]),
  print,
  ( Z == 42 -> refresh %print('The board is full and it is a tie.... you are equally useless! Write rematch if you want another go.'), nl
  ; row(M), X == p1 -> save(Stats), refresh,
    W4 is W2 + 1, setwins([W1,W4]) % print('We have a Winner and that is Maya the bot!!!'), nl
  ; row(M), X == p2 -> save(Stats), refresh,
  W3 is W1 + 1, setwins([W3,W2]) %print('We have a Winner and that is Player 1!!!'),  nl
  ; print(Turn), print(' next!'), nl).

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
  %; X == end_of_file  -> true
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

parse(Q, Res):-
  parse(Q, Res, []).
parse([[]], Res, Res):- !.
parse([[]|Rest], Y, Res):-
  !, parse(Rest, Y, Res).
parse([[o|T]|Rest], Y, Res):-
  parse([T|Rest], Y, [-1|Res]).
parse([[x|T]|Rest], Y, Res):-
  parse([T|Rest], Y, [1|Res]).
parse([[_|T]|Rest], Y, Res):-
  parse([T|Rest], Y, [0|Res]).

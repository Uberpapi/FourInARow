:-module(play, [echo/0, initiate/0, place/3, element/3]).
:-use_module(game).
:-use_module(rules).
:-use_module(printboard).
:-use_module(botlogic).
:-use_module(gamelog).
:-use_module(library(prologbeans)).
:-use_module(library(sockets)).
player(p1, 'Player 1').
player(p2, 'Player 2').

initiate:-
  setplayerturn(p1).
  %A socket Socket in the domain Domain is created.
  socket(+Domain, -Socket)
  socket_connect(+Socket, 'AF_INET'(+Host,+Port), -Stream)
  %The socket Socket is connected to the address. Stream
  %is a special stream on which items can be both read and written.
  ()'100.50.200.5', 4000)
/*Infinite echo where we play */
echo:-

  playerturn(T),
  write('>> '),
  ( T == p1 -> read(X), acceptedCommands(X), writeToLog(' Player'), writeToLog(X), call(X), echo
  ; T == p1 -> print('That is not a valid command, try again mate.'), nl, echo
  ; maya(Act), writeToLog(' Maya'), writeToLog(Act), call(Act), echo).

/* Creates the board and starts the game */
startgame:-
  retractall(board(_)),
  main,
  %setplayerturn(p1),
  getboard(Q)
  setboard(Q),
  print(' I can beat that ALBOT-bot. '),nl.


/*Refreshes the board */
refresh:-
  retractall(board(_)),
  createBoard(6, Q),
  setboard(Q),
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

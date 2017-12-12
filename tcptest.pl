:-use_module(library(sockets)).

initiate:-
  %The socket Socket is connected to the address. Stream
  %is a special stream on which items can be both read and written.
  socket_client_open('':4000, Stream, [type(text)]),
  readStream(Stream).
readStream(Stream):-
  read_line(Stream, X),
  print(X),nl,print(a),
  check(Stream, X),
  readStream(Stream).



check(Stream, [A1,32,A2,32,A3,32,A4,32,A5,32,A6,32,A7,32,
               B1,32,B2,32,B3,32,B4,32,B5,32,B6,32,B7,32,
               C1,32,C2,32,C3,32,C4,32,C5,32,C6,32,C7,32,
               D1,32,D2,32,D3,32,D4,32,D5,32,D6,32,D7,32,
               E1,32,E2,32,E3,32,E4,32,E5,32,E6,32,E7,32,
               F1,32,F2,32,F3,32,F4,32,F5,32,F6,32,F7,32]):-
  nl,
  print('We found board'),
  format(Stream, '~d', [3]),
  flush_output(Stream), nl,
  print('We sent move'), nl, !.
  
check(Stream, _).

check(_, [71,97,109,101,79,118,101,114]):-
  nl,
  print('Game is over').

send:-
  format(Stream, '~d', [3]), nl,
  print('We try again to send'), nl,
  readStream.

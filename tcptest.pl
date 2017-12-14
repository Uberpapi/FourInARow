:-module(tcptest, [initiateStream/0, check/2, readStream/1, send/0,
                   sendStream/1, closeStream/0]).
:-use_module(library(sockets)).
:-use_module(game).
:-use_module(library(system)).

initiateStream:-
  %The socket Socket is connected to the address. Stream
  %is a special stream on which items can be both read and written.
  retractall(stream(_)),
  socket_client_open('':4000, Stream, [type(text)]),
  print('Initiating Stream'), nl,
  setstream(Stream).

readStream(X):-
  sleep(1),
  stream(Stream),
  print('we are now trying to read....'),
  read_line(Stream, X), !, nl.

sendStream(Q):-
  print('Mayas move was just sent'), nl,
  print(Q), nl,
  stream(Stream),
  write(Stream, Q),
  flush_output(Stream).

closeStream:-
  print('closing stream'), nl,
  stream(Stream),
  close(Stream).

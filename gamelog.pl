:-module(gamelog, [writeToLog/1]).
writeToLog(nl):-
  open('gamelog.txt', append, Stream),
  nl(Stream),
  close(Stream),
  !.

writeToLog(X):-
  open('gamelog.txt', append, Stream),
  write(Stream, X),
  write(Stream, ', '),
  close(Stream).

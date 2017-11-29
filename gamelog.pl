:-module(gamelog, [writeToLog/1]).
:-use_module(game).

writeToLog(nl):-
  !, open('gamelog.txt', append, Stream),
  nl(Stream),
  close(Stream).


writeToLog(X):-
  reverseList(X, Rev),
  open('gamelog.txt', append, Stream),
  write(Stream, Rev),
  close(Stream).

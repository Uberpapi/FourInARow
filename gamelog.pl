:-module(gamelog, [writeToLog/1, sortLog/0]).
:-use_module(game).

writeToLog(nl):-
  !, open('gamelog2.txt', append, Stream),
  nl(Stream),
  close(Stream).

writeToLog(X):-
  reverseList(X, Rev),
  open('gamelog2.txt', append, Stream),
  write(Stream, Rev),
  write(Stream, '.'),
  close(Stream).

sortLog:-
  open('logicunique.txt', read, Stream),
  indexLog(Stream, Res, 1),
  close(Stream).


indexLog(Stream, [[Count, L]|Res], Count):-
  NewCount is Count + 1,
  \+at_end_of_stream(Stream),
  read(Stream, X),
  indexLog(Stream, Res, NewCount),
  listLength(X, L).
indexLog(Stream, [], Count):-
  print(Count), nl,
  at_end_of_stream(Stream).

listLength([], 0).
listLength([H|T], NewCount):-
  listLength(T, Count),
  NewCount is Count + 1.

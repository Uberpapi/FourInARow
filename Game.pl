:-module(game, [createBoard/2, hej/0]).
:-use_module(printboard).

/*Creates a a game Board with the
  size LengthXLength           */
createBoard(Length, Result):-
  createBoard(Length, [], 0, Res, 49),
  reverseList(Res, Result).

createBoard(Length, Result, Count, Result, _):-
  NewCount is Count - 1, NewCount == Length.
createBoard(Length, New, Count, Result, RowNr):-
  Count =< Length,
  fillList(Length, Res, RowNr),
  NewCount is Count + 1,
  NewRowNr is RowNr + 1,
  createBoard(Length, [Res|New], NewCount, Result, NewRowNr).

/*Fills the list with with elements
  equal to the amount of Length  */
fillList(Length, Result, RowNr):-
  fillList([], Length, Res, 0, 97, RowNr),
  reverseList(Res, Result).

fillList(Res, Length, Res, Length, _, _).
fillList(L, Length, Res, Count, Num, RowNr):-
  Count < Length,
  atom_codes(Q, [Num, RowNr]),
  NewNum is Num + 1,
  NewCount is Count + 1,
  fillList([Q|L], Length, Res, NewCount, NewNum, RowNr).

%Returns a given list reversed
reverseList(L, R):-
  reverseList(L, [], R).
reverseList([], R, R).
reverseList([H|T], Acc, R):-
  reverseList(T, [H|Acc], R).

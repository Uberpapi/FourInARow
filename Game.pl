
/*Creates a a game Board with the
  size LengthXLength           */
createBoard(Length, Result):-
  createBoard(Length, [], 0, Res, 49),
  reverseList(Res, Result).

createBoard(Length, Result, Length, Result, _).
createBoard(Length, New, Count, Result, RowNr):-
  Count < Length,
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

row(M):-
  tMatrix(M, R),
  (yRow(M) ; yRow(R); dRow(M)).

/*Checks if we have four in a
  row Vertical/Horisontal  */
yRow([[]|Rest]):-
  yRow(Rest).
yRow([[H,H,H,H|_]|_]).
yRow([[_|T]|Rest]):-
  yRow([T|Rest]).

/*Checks if we have four in a
  row diagonaly            */
dRow([[H|T]|Rest]):-


/*Returns a Matrix transposed*/
tMatrix([[]|_], []).
tMatrix(M, [L|R]):-
  getFirst(M, Rest, L), tMatrix(Rest, R).
getFirst([], [], []).
getFirst([[H|T]|Rest], [T|Q], [H|Res]):-
  getFirst(Rest, Q, Res).


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
  row diagonaly           */
dRow(M):-
  dRow(M, 1, 1).
dRow([[]|Rest], ColNr, _):-
  NewColNr is ColNr + 1,
  dRow(Rest, NewColNr, 1).
dRow(M, ColNr, RowNr):-
  listLength(M, Count),
  Count > 3,
  diagonal(M, RowNr, ColNr), print('Diagonal').
dRow([[_|T]|Rest], ColNr, RowNr):-
  NewRowNr is RowNr + 1,
  dRow([T|Rest], ColNr, NewRowNr).

/*Chooses where to check from depending on
  which RowNumber we are currently on   */
diagonal([[H|T]|Rest], RowNr, ColNr):-
  RowNr < 3,
  diagonalU([[H|T]|Rest], RowNr, ColNr, 0,  H).
diagonal([[H|T]|Rest], RowNr, ColNr):-
  RowNr > 3,
  diagonalD([[H|T]|Rest], RowNr, ColNr, 0,  H).

/*Checking if we have 4 in a row
  diagonaly from up to down   */
diagonalU(_, _, _, 3, _).
diagonalU([[H|T]|Rest], RowNr, ColNr, Count, Ele):-
  NewRowNr is RowNr + 1,
  NewColNr is ColNr + 1,
  getRow([[H|T]|Rest], NewColNr, Row),
  getElement(Row, NewRowNr, Ele),
  NewCount is Count + 1,
  diagonalU(Rest, NewRowNr, ColNr, NewCount, Ele).

/*Checking if we have 4 in a row
  diagonaly from down to up   */
diagonalD(_, _, _, 3, _).
diagonalD([[H|T]|Rest], RowNr, ColNr, Count, Ele):-
  NewRowNr is RowNr - 1,
  NewColNr is ColNr + 1,
  getRow([[H|T]|Rest], NewColNr, Row),
  getElement(Row, NewRowNr, Ele),
  NewCount is Count + 1,
  diagonalD(Rest, NewRowNr, ColNr, NewCount, Ele).

/*Returns the nth Row */
getRow([Row|_], 1, Row).
getRow([_|Rest], Count, Row):-
  NewCount is Count - 1,
  getRow(Rest, NewCount, Row).

/*Returns the nth Element */
getElement([Element|_], 1, Element).
getElement([_|Rest], Count, Element):-
  NewCount is Count - 1,
  getElement(Rest, NewCount, Element).

/*Returns a Matrix transposed*/
tMatrix([[]|_], []).
tMatrix(M, [L|R]):-
  getFirst(M, Rest, L), tMatrix(Rest, R).

getFirst([], [], []).
getFirst([[H|T]|Rest], [T|Q], [H|Res]):-
  getFirst(Rest, Q, Res).

%Returns the length of a list
listLength([], 0).
listLength([_|Rest], NewLength):-
  listLength(Rest, Length), NewLength is Length + 1.

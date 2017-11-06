:-module(rules, [row/1, getRow/3, getElement/3, listLength/2,
                 place/3, element/4]).
:-use_module(game).


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
  diagonal(M, RowNr, ColNr).
dRow([[_|T]|Rest], ColNr, RowNr):-
  NewRowNr is RowNr + 1,
  dRow([T|Rest], ColNr, NewRowNr).

/*Chooses where to check from depending on
  which RowNumber we are currently on   */
diagonal([[H|T]|Rest], RowNr, ColNr):-
  RowNr =< 3,
  diagonalU([[H|T]|Rest], RowNr, ColNr, 0,  H).
diagonal([[H|T]|Rest], RowNr, ColNr):-
  RowNr >= 3,
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


/*Returns the nth Row from a Matrix*/
getRow([Row|_], 1, Row).
getRow([_|Rest], Count, Row):-
  NewCount is Count - 1,
  getRow(Rest, NewCount, Row).

/*Returns the nth Element from a List*/
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

place(Q, Nr, Y):-
  place(Q, Nr, Nr, Y).

place([], _, _, []).
place([Row|T], 1, ColNr, [NewRow|Y]):-
  playerturn(X),
  reverseList(Row, RevRow), print(RevRow), nl,
  element(RevRow, RevNewRow, X, Swap),
    ( Swap == yes, X == p1 -> setplayerturn(p2)
    ; Swap == yes, X == p2 -> setplayerturn(p1)
    ; setplayerturn(X)),
  reverseList(RevNewRow, NewRow), print(NewRow), nl,
  place(T, 0, _, Y).
place([H|T], Nr, ColNr, [H|Y]):-
  NewNr is Nr - 1,
  place(T, NewNr, ColNr, Y).

element([], [], done, yes):- !.
element([], [], _, no):-
  print('This column is alredy full, please select another one or forfeit to your obviously superior opponent.'), nl.
element([H|T], [H|Y], done, Swap):-
    element(T, Y, done, Swap).
element([o|T], [o|Y], Turn, Swap):-
    element(T, Y, Turn, Swap).
element([x|T], [x|Y], Turn, Swap):-
   element(T, Y, Turn, Swap).
element([H|T], [x|Y], p1, Swap):-
   print(H),  nl, element(T, Y, done, Swap).
element([H|T], [o|Y], p2, Swap):-
   element(T, Y, done, Swap).

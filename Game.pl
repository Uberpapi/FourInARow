
/*Creates a a game Board with the
  size length X length*/

createBoard(Length, Result):-
  createBoard(Length, [], 0, Result).

createBoard(Length, Result, Length, Result).
createBoard(Length, New, Count, Result):-
  Count < Length,
  NewCount is Count + 1,
  createBoard(Length, [[]|New], NewCount, Result).

row(M):-
  tMatrix(M, R),
  (yRow(M) ; xRow(R)). %Lägg till diagonal

yRow([]).
yRow([[]|Rest]):-
  yRow(Rest).
yRow([H,H,H,H|_]):- !.
yRow([[H|T]|Rest]):-
  yRow([T|Rest]).

%xRow(M).

getFirst([], [], []).
getFirst([[H|T]|Rest], [T|Q], [H|Res]):-
  getFirst(Rest, Q, Res).

/*Returns a Matrix transposed*/
tMatrix([], []).
tMatrix(M, [L|R]):-
   getFirst(M, Rest, L), tMatrix(Rest, R).

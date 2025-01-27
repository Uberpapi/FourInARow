:-module(game, [createBoard/2, board/1, playerturn/1, setboard/1,
                setplayerturn/1, reverseList/2, setturns/1, turns/1,
                wins/1, setwins/1, save/1, setsave/1, setstream/1, stream/1]).

/*We use dynamics to store variables */
:- dynamic board/1.
:- dynamic playerturn/1.
:- dynamic turns/1.
:- dynamic wins/1.
:- dynamic save/1.
:- dynamic stream/1.

/*Creates a a game Board with the
  size N x N+1           */
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

setboard(_):-
  retract(board(_)),
  fail.
setboard(X):-
  assert(board(X)).
setplayerturn(_):-
  retract(playerturn(_)),
  fail.
setplayerturn(X):-
  assert(playerturn(X)).
setturns(_):-
  retract(turns(_)),
  fail.
setturns(X):-
  assert(turns(X)).
setwins(_):-
  retract(wins(_)),
  fail.
setwins(X):-
  assert(wins(X)).
setsave(_):-
  retract(save(_)),
  fail.
setsave(X):-
  assert(save(X)).
setstream(_):-
  retract(stream(_)),
  fail.
setstream(X):-
  assert(stream(X)).

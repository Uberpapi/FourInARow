:-module(printboard, [print/0]).
:-use_module(game).
:-use_module(rules).

/* Prints our current board */
print:-
  createBoard(6, Q), transformValue(Q, A),
  getRow(A, 1, B), getRow(A, 2, C), getRow(A, 3, D), getRow(A, 4, E), getRow(A, 5, F), getRow(A, 6, G), getRow(A, 7, H),
  getElement(B, 1, A1), getElement(B, 2, A2), getElement(B, 3, A3), getElement(B, 4, A4), getElement(B, 5, A5), getElement(B, 6, A6),
  getElement(C, 1, B1), getElement(C, 2, B2), getElement(C, 3, B3), getElement(C, 4, B4), getElement(C, 5, B5), getElement(C, 6, B6),
  getElement(D, 1, C1), getElement(D, 2, C2), getElement(D, 3, C3), getElement(D, 4, C4), getElement(D, 5, C5), getElement(D, 6, C6),
  getElement(E, 1, D1), getElement(E, 2, D2), getElement(E, 3, D3), getElement(E, 4, D4), getElement(E, 5, D5), getElement(E, 6, D6),
  getElement(F, 1, E1), getElement(F, 2, E2), getElement(F, 3, E3), getElement(F, 4, E4), getElement(F, 5, E5), getElement(F, 6, E6),
  getElement(G, 1, F1), getElement(G, 2, F2), getElement(G, 3, F3), getElement(G, 4, F4), getElement(G, 5, F5), getElement(G, 6, F6),
  getElement(H, 1, G1), getElement(H, 2, G2), getElement(H, 3, G3), getElement(H, 4, G4), getElement(H, 5, G5), getElement(H, 6, G6),

  format('        ~`-t~49|~n', []),
  format('     1 |  ~t~w~10|~t~w~t~2+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~|~49||~n',[A1,'  |  ', B1,'  |  ',C1,'  |  ',D1, '  |  ',E1,'  |  ',F1, '  |  ', G1]),
  format('       |~t~w~10|~t|~49|~n', ['-----------------------------------------'] ),
  format('     2 |  ~t~w~10|~t~w~t~2+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~|~49||~n',[A2,'  |  ', B2,'  |  ',C2,'  |  ',D2, '  |  ',E2,'  |  ',F2, '  |  ', G2]),
  format('       |~t~w~10|~t|~49|~n', ['-----------------------------------------'] ),
  format('     3 |  ~t~w~10|~t~w~t~2+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~|~49||~n',[A3,'  |  ', B3,'  |  ',C3,'  |  ',D3, '  |  ',E3,'  |  ',F3, '  |  ', G3]),
  format('       |~t~w~10|~t|~49|~n', ['-----------------------------------------'] ),
  format('     4 |  ~t~w~10|~t~w~t~2+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~|~49||~n',[A4,'  |  ', B4,'  |  ',C4,'  |  ',D4, '  |  ',E4,'  |  ',F4, '  |  ', G4]),
  format('       |~t~w~10|~t|~49|~n', ['-----------------------------------------'] ),
  format('     5 |  ~t~w~10|~t~w~t~2+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~|~49||~n',[A5,'  |  ', B5,'  |  ',C5,'  |  ',D5, '  |  ',E5,'  |  ',F5, '  |  ', G5]),
  format('       |~t~w~10|~t|~49|~n', ['-----------------------------------------'] ),
  format('     6 |  ~t~w~10|~t~w~t~2+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~t~1+~w~|~49||~n',[A6,'  |  ', B6,'  |  ',C6,'  |  ',D6, '  |  ',E6,'  |  ',F6, '  |  ', G6]),
  format('        ~`-t~49|~n', []),
  print('          A     B     C     D     E     F     G ').


/* Transforms all non x/o to another
   character of our choosing      */
transformValue([], []).
transformValue([H|T], [Res|R]):-
  transformValue(T, R), assign(H, Res).

assign([], []).
assign([o|T], ['O'|Q]):-
  !, assign(T, Q).
assign([x|T], ['X'|Q]):-
  !, assign(T, Q).
assign([_|T], ['X'|Q]):-
  assign(T, Q).

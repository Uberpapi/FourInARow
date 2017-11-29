:-module(randombot, [randomact/1, generate/0]).
:-use_module(library(random)).

value(a, 1). value(b, 2). value(c, 3).
value(d, 4). value(e, 5). value(f, 6). value(g, 7).

randomact(Act):-
  random(1,8,Number),
  value(Act, Number).

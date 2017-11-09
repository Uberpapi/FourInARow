%GENETICAL ALGORITHM FOR FYRA I RAD
%ALEX L, ANTON A

:-module(gaBot, [applMutation/4, newGeneration/2, newGenome/2]).
:-use_module(game).
:-use_module(rules).
:-use_module(printboard).
:-use_module(library(random)).

% Takes a list of genomes,(lists of weights for specific actions), generates new genomes based on the genomes
newGeneration(Q, Generation):-
  newGeneration(Q, [], Generation).

newGeneration([], Generation, Generation).
newGeneration([OldGenome|Rest], R):-
  newGenome(OldGenome, NewGenomes),
  newGeneration(Rest, [NewGenomes|R]).

newGenome(Q, Genomes):-
  newGenome(Q, [], Genomes).
newGenome([], Genomes, Genomes).
newGenome([H|Rest], Genomes, R):-
  applMutation(H, 0.975, 1.025, MutVal),
  newGenome(Rest, [MutVal|Genomes], R).

% Applies specified MUTATION to some initial value.
applMutation(InitVal, Lo, Hi, MutVal):-
  random(Lo, Hi, Number),
  MutVal is InitVal * Number.

% FITTNES

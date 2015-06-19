-module(mylists).
-export([sum/1,map/2]).

sum([H|L])->H + sum(L);
sum([])-> 0.

map(_, [])->[];
map(F, [H|T])->[F(H)|map(F,T)].

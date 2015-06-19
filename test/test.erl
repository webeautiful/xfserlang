-module(test).
-export([test/1,max/2]).

test(Data)->
    binary_to_list(base64:encode(Data)).
max(X, Y) when X > Y -> X;
max(_, Y)->Y.

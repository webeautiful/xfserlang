-module(dog_fsm).
-export([start/0, squirrel/1, pet/1]).

start() ->
    spawn(fun() -> bark() end).

squirrel(Pid) -> Pid ! squirrel.
pet(Pid) -> Pid ! pet.

bark() ->
    receive
        pet -> wag_tail();
        _ ->
        io:format("Dog is confused~n"),
        bark()
    end.
wag_tail() ->
    receive
        pet -> sit();
        _ ->
        io:format("Dog is confused~n"),
        wag_tail()
    end.
sit() ->
    receive
        squirrel -> bark();
        _ ->
        io:format("Dog is confused~n"),
        sit()
    end.

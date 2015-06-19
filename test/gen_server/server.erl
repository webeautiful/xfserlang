-module(server).
-export([start/2,call/2,cast/2]).

start(Name, Mod)->
    register(Name,spawn(fun()->loop(Name, Mod, Mod:init()) end)).

loop(Name, Mod, State)->
    receive
        {From, {call, Request}}->
            {Response, NewState} = Mod:handle_call(Request, State),
            From ! {Name, Response},
            loop(Name, Mod, NewState);
        {From, {cast, Request}}->
            {Response, NewState} = Mod:handle_cast(Request, State),
            From ! {Name, Response},
            loop(Name, Mod, NewState)
    end.

call(Name, Request)->
    Name ! {self(), {call, Request}},
    receive
        {Name, Response} -> Response
    end.
cast(Name, Request)->
    Name ! {self(), {cast, Request}}.

-module(storage).
-export([init/0, handle_call/2, add/2, find/1, start/0]).

init()->
    dict:new().

handle_call({add, Key, Value}, Dict)->
    {ok, dict:store(Key, Value, Dict)};
handle_call({find, Key}, Dict)->
    {dict:find(Key, Dict), Dict}.

% client
start()->
    server:start(kv_server, ?MODULE).
add(Key, Value)->
    server:call(kv_server, {add, Key, Value}).
find(Key)->
    server:call(kv_server, {find, Key}).

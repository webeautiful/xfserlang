-module(new_storage).
-behaviour(gen_server).
-export([start/0, stop/0, add/2, find/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start()->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop()->
    gen_server:call(?MODULE, stop).
add(Key, Value)->
    gen_server:call(?MODULE, {add, Key, Value}).
find(Key)->
    gen_server:call(?MODULE, {find, Key}).

init([]) ->
    {ok, dict:new()}.
handle_call({add, Key, Value}, _From, Dict)->
    Reply = dict:store(Key, Value, Dict),
    {reply, ok, Reply};
handle_call({find, Key}, _From, Dict)->
    Reply = dict:find(Key, Dict),
    {reply, Reply, Dict}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, Extra) -> {ok, State}.

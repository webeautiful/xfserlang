-module(write_log).
-export([write_in_file/0]).

-include("records.hrl").

write_in_file() ->
    mylog(?MODULE, #xmlel{}).

%% internal function
mylog(File,Data) ->
    {ok, IoDevice} = file:open(File, [append]), %write,append,read等
    io:format(IoDevice, "~p~n=============~n", [Data]), %~p,~w,~s的区别
    file:close(IoDevice),
    ok.

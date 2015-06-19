%% http://www.cnblogs.com/me-sa/archive/2011/11/05/erlang0012.html
-module(looper).
-compile(export_all).

start()->
    spawn(looper, loop, []).

loop()->
    receive
        abc ->
            io:format("Receive abc. ~n"),
            loop();
        stop ->
            io:format("stop"),
            stop
    end.

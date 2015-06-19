-module(afile_server).
-export([start/1, loop/1]).

start(Dir)->
    spawn(afile_server, loop, [Dir]).

loop(Dir)->
    receive
        {Client, list_dir}->
            Client ! {a, file:list_dir(Dir)};
        {Client,{get_file, File}}->
            Full = filename:join(Dir,File),
            Client ! {b, file:read_file(Full)}
    end,
loop(Dir).

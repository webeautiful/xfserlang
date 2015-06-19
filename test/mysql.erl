%%-module(mysql).
%%-compile(export_all).
%%
%%mysql_connect(Server, Port, DB, Username, Password) ->
%%    case p1_mysql_conn:start(binary_to_list(Server), Port,
%%                          binary_to_list(Username), binary_to_list(Password),
%%              binary_to_list(DB))
%%    of  
%%      {ok, Ref} ->
%%      p1_mysql_conn:fetch(Ref, [<<"set names 'utf8';">>],
%%               self()),
%%      {ok, Ref};
%%      Err -> Err 
%%    end.
-module(mysql_test).
-export([start/0]).
 
start () ->
 
    % 连接数据库
    mysql:start_link(conn1, "localhost", "root", "ybybyb", "webgame"),
 
    % 插入数据
    Result1 = mysql:fetch(
        conn1,
        [<<
        "INSERT INTO"
        "        `player`"
        "    SET"
        "        `username`         = 'test',"
        "        `joined_datetime`  = now(),"
        "        `logined_datetime` = now();"
        >>]
    ),
 
    io:format("Result1: ~p~n", [Result1]),

    % 查询数据
    Result2 = mysql:fetch(conn1, [<<"SELECT * FROM player">>]),
 
    io:format("Result2: ~p~n", [Result2]),
 
    % 更新数据
    Result3 = mysql:fetch(
        conn1,
        [<<
        "UPDATE"
        "    `player`"
        "SET"
        "    `username` = 'test_player'"
        "where"
        "    `username` = 'test'"
        >>]
    ),
 
    io:format("Result3: ~p~n", [Result3]),
 
    % 查询数据
    Result4 = mysql:fetch(conn1, [<<"SELECT * FROM player">>]),
 
    io:format("Result4: ~p~n", [Result4]),
 
    % 删除数据
    Result5 = mysql:fetch(
        conn1,
        [<<
        "DELETE FROM `player` WHERE `username` = 'test_player'"
        >>]
    ),
 
    io:format("Result5: ~p~n", [Result5]),
 
    % 查询数据
    Result6 = mysql:fetch(conn1, [<<"SELECT * FROM player">>]),
 
    io:format("Result4: ~p~n", [Result6]),
 
    ok.



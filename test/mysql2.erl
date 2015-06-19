-module(mysql2).
-compile(export_all).

start()->
    % 连接数据库
    mysql:start_link(conn1, "192.168.1.64", "cikuu", "cikuutest!", "ejabberd"),
    % 查询数据
    Result2 = mysql:fetch(conn1, [<<"SELECT * FROM users">>]),
 
    io:format("Result2: ~p~n", [Result2]),

    ok.

-module(mn).
-export([start/0]).

-include_lib("stdlib/include/qlc.hrl").

%% 账号表结构
-record(y_account, {id, account, password}).
%% 资料表结构
-record(y_info, {id, nickname, birthday, sex}).

%%===============================================
%%  create table y_account ( id int, account varchar(50),
%%   password varchar(50),  primary key(id)) ;
%%===============================================

%% 使用 mnesia:create_table
mnesia:create_table( y_account,[{attributes, record_info(fields, y_account)} ,
  {type,set}, {disc_copies, [node()]} ]).

%%===============================================
%%  drop table y_account; 删除表操作
%%===============================================

%% 使用 mnesia:delete_table
mnesia:delete_table(y_account).

%%===============================================
%%  select * from y_account 查询全部记录
%%===============================================

%% 使用 mnesia:select
F = fun() ->
    MatchHead = #y_account{ _ = '_' },
    Guard = [],
    Result = ['$_'],
    mnesia:select(y_account, [{MatchHead, Guard, Result}])
end,
mnesia:transaction(F).

%% 使用 qlc
F = fun() ->
    Q = qlc:q([E || E <- mnesia:table(y_account)]),
    qlc:e(Q)
end,
mnesia:transaction(F).

%%===============================================
%%  select id,account from y_account 查询部分字段的记录
%%===============================================

%% 使用 mnesia:select
F = fun() ->
    MatchHead = #y_account{id = '$1', account = '$2', _ = '_' },
    Guard = [],
    Result = ['$$'],
    mnesia:select(y_account, [{MatchHead, Guard, Result}])
end,
mnesia:transaction(F).

%% 使用 qlc
F = fun() ->
    Q = qlc:q([[E#y_account.id, E#y_account.account] || E <- mnesia:table(y_account)]),
    qlc:e(Q)
end,
mnesia:transaction(F).


%%===============================================
%%    insert into y_account (id,account,password) values(5,"xiaohong","123")
%%     on duplicate key update account="xiaohong",password="123";
%% mnesia是根据主键去更新记录的，如果主键不存在则插入
%%===============================================

%% 使用 mnesia:write
F = fun() ->
    Acc = #y_account{id = 5, account="xiaohong", password="123"},
    mnesia:write(Acc)
end,
mnesia:transaction(F).

%%===============================================
%%    select account from y_account where id>5
%%===============================================

%% 使用 mnesia:select
F = fun() ->
    MatchHead = #y_account{id = '$1', account = '$2', _ = '_' },
    Guard = [{'>', '$1', 5}],
    Result = ['$2'],
    mnesia:select(y_account, [{MatchHead, Guard, Result}])
end,
mnesia:transaction(F).

%% 使用 qlc
F = fun() ->
    Q = qlc:q([E#y_account.account || E <- mnesia:table(y_account), E#y_account.id>5]),
    qlc:e(Q)
end,
mnesia:transaction(F).

%%===============================================
%% Where 查询
%%    select account from y_account where id>5
%%===============================================

%% 使用 mnesia:select
F = fun() ->
    MatchHead = #y_account{id = '$1', account = '$2', _ = '_' },
    Guard = [{'>', '$1', 5}],
    Result = ['$2'],
    mnesia:select(y_account, [{MatchHead, Guard, Result}])
end,
mnesia:transaction(F).

%% 使用 qlc
F = fun() ->
    Q = qlc:q([E#y_account.account || E <- mnesia:table(y_account), E#y_account.id>5]),
    qlc:e(Q)
end,
mnesia:transaction(F).

%%
%% 简单列表处理
%%
-module(shop2).
-export([total/1]).
-import(lists,[map/2,sum/1]).

total(L)->
    sum(map(fun({What, N})->shop:cost(What) * N end,L)).%% 依赖shop.beam模块

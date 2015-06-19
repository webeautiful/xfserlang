-module(shop1).
-export([total/1]).

total([{What, N}|T])-> %% 参数为非空列表
    shop:cost(What) * N + total(T);
total([])->0. %% 空列表

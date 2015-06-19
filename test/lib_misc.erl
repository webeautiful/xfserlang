-module(lib_misc).
-export([for/3,qsort/1,pythag/1,perms/1,odds_and_evens1/1,odds_and_evens2/1]).

for(Max, Max, F)->[F(Max)];
for(I, Max, F)->[F(I)|for(I+1, Max, F)].

%% 快排
qsort([])->[];
qsort([Pivot|T])->
    qsort([X||X<-T,X<Pivot])
    ++ [Pivot] ++
    qsort([X||X<-T,X>=Pivot]).

%% 毕达哥拉斯三元数组
pythag(N)->
    [{A,B,C} ||
        A<-lists:seq(1,N),
        B<-lists:seq(1,N),
        C<-lists:seq(1,N),
        A+B+C=<N,
        A*A+B*B=:=C*C
    ].

%% 回文构词(anagram)
perms([])->[[]];
perms(L)->
    [[H|T]||H <- L,T <- perms(L--[H])].

%% 归集器
odds_and_evens1(L)->
    Odds = [X||X <- L, (X rem 2) =:= 1], %%奇数
    Evens = [X||X <- L, (X rem 2) =:= 0], %%偶数
    {Odds,Evens}.

%% 避免列表遍历2次
odds_and_evens_acc([H|T], Odds, Evens)->
    case (H rem 2) of
        1->
            odds_and_evens_acc(T, [H|Odds], Evens); %%奇数
        0->
            odds_and_evens_acc(T, Odds, [H|Evens]) %%偶数
    end.
%% odds_and_evens_acc([],Odds,Evens)->{Odds,Evens}.
odds_and_evens2(L)->
    odds_and_evens_acc(L,[],[]).

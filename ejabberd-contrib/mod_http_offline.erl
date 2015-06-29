-module(mod_http_offline).
-author("xiongfusong@gmail.com").
-behaviour(gen_mod).

-export([start/2, stop/1, create_message/3]).

-include("ejabberd.hrl").
-include("jlib.hrl").

start(Host, _Opt) ->
    inets:start(),
    ejabberd_hooks:add(offline_message_hook, Host, ?MODULE, create_message, 50).

stop(Host) ->
    ejabberd_hooks:delete(offline_message_hook, Host, ?MODULE, create_message, 50).

create_message(From, To, Packet) ->
    %Type = xml:get_tag_attr_s(list_to_binary("type"), Packet),
    FromS = From#jid.luser, %xml:get_tag_attr_s(list_to_binary("from"), Packet),
    ToS = To#jid.luser, %xml:get_tag_attr_s(list_to_binary("to"), Packet),
    Body = xml:get_path_s(Packet, [{elem, list_to_binary("body")}, cdata]),
    % if (Type == <<"chat">>) and (Body /= <<"">>) ->
    post_offline_message(FromS, ToS, Body).
    % end.

post_offline_message(From, To, Body) ->
    httpc:request(post,
        {"http://192.168.1.67:81/im/app/push_notification_for_ios.php",
        [],
        "application/x-www-form-urlencoded",
        list_to_binary(["from=", From, "&to=", To, "&body=", Body])}, [], []).

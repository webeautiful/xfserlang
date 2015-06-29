-module(mod_muc_http).
-author("xiongfusong@gmail.com").
-behaviour(gen_mod).

-export([start/2, stop/1, send_msg/3]).

-include("ejabberd.hrl").
-include("jlib.hrl").

start(_Host, _Opt) ->
    inets:start(),
    ejabberd_hooks:add(user_send_packet, _Host, ?MODULE, send_msg, 50).
    %ejabberd_hooks:add(user_receive_packet, _Host, ?MODULE, receive_msg, 50).

stop(_Host) ->
    %ejabberd_hooks:delete(user_receive_packet, _Host, ?MODULE, receive_msg, 50).
    ejabberd_hooks:delete(user_send_packet, _Host, ?MODULE, send_msg, 50).


send_msg(From, To, Packet) ->
      %?DEBUG("xiongfusong: ~s, ~s, ~s",
      %   [jlib:jid_to_string(From), jlib:jid_to_string(To), Packet]),
    FromS = From#jid.luser,
    ToS = jlib:jid_to_string(To),
    Type = xml:get_tag_attr_s(list_to_binary("type"), Packet),
    Body = xml:get_path_s(Packet, [{elem, list_to_binary("body")}, cdata]),
    if (Type == <<"groupchat">>) ->
        post_http_msg(FromS, ToS, Body);
        true ->
            none
    end.
post_http_msg(From, To, Body) ->
    httpc:request(post,
        {"http://192.168.1.67:81/im/app/muc_http.php",
        [],
        "application/x-www-form-urlencoded",
        list_to_binary(["from=", From, "&to=", To, "&body=", Body])}, [], []).


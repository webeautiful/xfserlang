ejabberd模块扩展
===

* `mod_http_offline.erl` 添加钩子`offline_message_hook`,通过http协议向外部接口`post`数据,从而实现用php或其他熟悉的语言进行ios的离线消息推送
* `mod_muc_http.erl` 添加钩子`user_send_packet`,通过http协议向外部接口`post`数据,从而实现用php或其他熟悉的语言进行群聊消息的持久化存储
* `mod_muc_presence` 添加钩子`c2s_presence_in`,当用户登录时自动将其加入之前加入过的聊天室

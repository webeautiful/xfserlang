#ejabberd数据结构
数据结构是分析源码的重要基础，如果对ejabberd的数据结构不熟悉，会给阅读理解带来不小的障碍。  
为了以后翻阅方便，在这里对一些关键的record数据作更详细的注释。

>说明：该文档并不能做到一蹴而就，而是在阅读源码的过程中，对程序的理解,一点点积累和完善的结果

### 群聊(muc)

**mod_muc_room.hrl**

##### 聊天室配置
```erlang
-define(MAX_USERS_DEFAULT, 200).
-record(config,
{
    title                                = <<"">> :: binary(),
    description                          = <<"">> :: binary(),
    allow_change_subj                    = true :: boolean(),
    allow_query_users                    = true :: boolean(),
    allow_private_messages               = true :: boolean(),
    allow_private_messages_from_visitors = anyone :: anyone | moderators | nobody ,
    allow_visitor_status                 = true :: boolean(),
    allow_visitor_nickchange             = true :: boolean(),
    public                               = true :: boolean(),
    public_list                          = true :: boolean(),
    persistent                           = false :: boolean(),
    moderated                            = true :: boolean(),
    captcha_protected                    = false :: boolean(),
    members_by_default                   = true :: boolean(),
    members_only                         = false :: boolean(),
    allow_user_invites                   = false :: boolean(),
    password_protected                   = false :: boolean(),
    password                             = <<"">> :: binary(),
    anonymous                            = true :: boolean(),
    allow_voice_requests                 = true :: boolean(),
    voice_request_min_interval           = 1800 :: non_neg_integer(),
    max_users                            = ?MAX_USERS_DEFAULT :: non_neg_integer() | none,
    logging                              = false :: boolean(),
    vcard                                = <<"">> :: binary(),
    captcha_whitelist                    = (?SETS):empty() :: ?TGB_SET
}).
```
* allow_private_messages 设置聊天室是否允许私聊
* allow_private_messages_from_visitors 设置访客能够发起私聊的对象
* max_users-单独设置每个聊天室可容纳的人数,该值不能超过`mod_muc`模块全局配置项`max_users`的值

##### 聊天室状态

```erlang
-type role() :: moderator | participant | visitor | none.

-record(user,         % 用户在聊天室中个人信息(?DICT)
{
    jid :: jid(),     % online用户#jid{}
    nick :: binary(), % online用户在聊天室中的昵称
    role :: role(),   % 用户在聊天室中的角色
    last_presence :: xmlel() % #xmlel{}
}).

-record(lqueue,       % 记录最新的len条群聊消息(len<=max)
{
    queue :: ?TQUEUE,
    len :: integer(),
    max :: integer()
}).
-type lqueue() :: #lqueue{}.

-record(state,
{
    room                    = <<"">> :: binary(),
    host                    = <<"">> :: binary(),
    server_host             = <<"">> :: binary(),
    access                  = {none,none,none,none} :: {atom(), atom(), atom(), atom()},
    jid                     = #jid{} :: jid(),
    config                  = #config{} :: config(),
    users                   = (?DICT):new() :: ?TDICT,
    last_voice_request_time = treap:empty() :: treap:treap(),
    robots                  = (?DICT):new() :: ?TDICT,
    nicks                   = (?DICT):new() :: ?TDICT,
    affiliations            = (?DICT):new() :: ?TDICT,
    history                 :: lqueue(),
    subject                 = <<"">> :: binary(),
    subject_author          = <<"">> :: binary(),
    just_created            = false :: boolean(),
    activity                = treap:empty() :: treap:treap(),
    room_shaper             = none :: shaper:shaper(),
    room_queue              = queue:new() :: ?TQUEUE
}).
```
* room - 聊天室名(聊天室的唯一标识)
* host - 群聊服务名,如:<<"conference.192.168.1.67">>
* server_host - 虚拟主机名(节点名)
* access - 由mod_muc模块的配置项access,access_create,access_admin,access_persistent的值组成的四元组,分别表示聊天室的使用权限, 创建权限, 管理所有聊天室的权限和聊天室配置的修改权限}
* jid - 某房客的群聊jid,由room,host,房客昵称组成的记录#jid{}(标准的JID格式:#jid{user,server,resource,luser,lserver,lresource})
* config - 聊天室的配置项集合,数据类型为record
* subject - 聊天室名称/主题
* nicks - 一个Key-Value字典，当前聊天室用户昵称管理,Key为用户在聊天室中的`昵称`，Value是`{User, Server, Resource}`三元组构成的列表
* users - 一个Key-Value字典,存储当前聊天室的online用户，Key为`{Luser, Lserver, Lresource}`组成的三元组,Vaule为记录#user{}
* affiliations - 聊天室与用户的隶属关系,一个Key-Value字典,Key为`{Luser, Lserver, Lresource}`组成的三元组,Value为`member | admin | owner | none`
* activity - Treap(带优先级的平衡二叉树tree+heap)实现的Key-Value存储结构,Key为`{Luser, Lserver, Lresource}`,Value为记录#activity{}
* room_shaper - 聊天室流量控制,存储的数据为通过ets存储于内存的记录#shaper{},主键name为流量类型(二元组), 值#maxrate{}是由{maxrate,lastrate,lasttime}组成的记录
* history - 队列循环存储最新的群聊消息，为记录#lqueue{queue = Q, len = L, max = M},queue为erlang内部模块queue实现的队列,单条队列数据是由{消息发送者nick,消息体#xmlel{},聊天室是否有subject,发送时间以及消息体size}组成的元组;len的值为当前队列的长度;max的值为mod_muc的配置项history_size的值,限制存储群聊消息的条数
* room_queue - erlang内部模块queue实现的队列

##### 聊天室中的在线用户(ets)
```erlang
-record(muc_online_users,
{
    us = {<<>>, <<>>} :: {binary(), binary()},
    resource = <<>> :: binary() | '_',
    room = <<>> :: binary() | '_' | '$1',
    host = <<>> :: binary() | '_' | '$2'
}).

-type muc_online_users() :: #muc_online_users{}.
```
* us - {用户名，server名}组成的二元组
* resource - 客户端连接资源
* room - 聊天室名
* host - 群聊服务名,如:<<"conference.192.168.1.67">>

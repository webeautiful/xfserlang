#ejabberd数据结构
数据结构是分析源码的重要基础，如果对ejabberd的数据结构不熟悉，会给阅读理解带来不小的障碍。  
为了以后翻阅方便，在这里对一些关键的record数据作更详细的注释。

>说明：该文档并不能做到一蹴而就，而是在阅读源码的过程中，对程序的理解,一点点积累和完善的结果

### 群聊(muc)
```erlang
-type role() :: moderator | participant | visitor | none.

-record(user,
{
    jid :: jid(),
    nick :: binary(),
    role :: role(),
    last_presence :: xmlel()
}).

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
* host - muc服务名,如:`conference.192.168.1.67`
* server_host - 虚拟主机名(节点名)
* jid - 聊天室room,host组成的#jid{}
* config - 聊天室的配置项集合,数据类型为record
* subject - 聊天室名称/主题
* nicks - 用户昵称管理,一个Key-Value字典，Key为用户在聊天室中的`昵称`，Value为`{User, Server, Resource}`组成的三元组
* users - 用户角色管理,一个Key-Value字典,Key为`{Luser, Lserver, Lresource}`组成的三元组,Vaule为记录#user{}
* affiliations - 隶属关系管理,一个Key-Value字典,Key为`{Luser, Lserver, Lresource}`组成的三元组,Value为`member | admin | owner | none`
* activity - Treap(带优先级的平衡二叉树tree+heap)实现的Key-Value存储结构,Key为`{Luser, Lserver, Lresource}`,Value为记录#activity{}

```erlang
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

* allow_private_messages


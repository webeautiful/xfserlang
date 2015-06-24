#ejabberd的线上部署之mysql替代mnesia进行持久化存储

## 导入mysql表结构

表结构位于`/opt/ejabberd-15.04/lib/ejabberd-15.04/priv/sql/mysql.sql`,至于如何导入就不在这里赘述了！

## 修改配置`ejabberd.yml`

认证方式:

```
##auth_method: internal
auth_method: odbc
```

mysql连接配置:

```
odbc_type: mysql
odbc_server: "server"
odbc_database: "database"
odbc_username: "username"
odbc_password: "password"
```

模块配置

> mod_last  - 最后在线日期和时间
> mod_offline - 离线消息
> mod_roster - 通讯录
> mod_vcard - 个人资料
> mod_muc - 聊天室
> mod_private - 私有XML存储
> mod_privacy - 用户黑名单
> mod_ping

以上模块均支持mysql存储，配置方法：添加db_type: odbc属性

>mod_pubsub -> mod_pubsub_odbc - 发布与订阅

该模块与以上模块不同，是为mod_pubsub加后缀_odbc

## 重启ejabberd服务器
`
$ ./bin/ejabberdctl restart
`

#ejabberd的线上部署之二进制安装

##将[ejabberd15.04.run][1]通过scp命令上传到线上服务器
##root账号下安装 `./ejabberd15.04.run`
* 选择安装语言`简体中文[6]`
* 接受授权协议
* 选择安装目录（默认）
* 填写ejabberd服务器域（输入本机的IP地址）
* 创建管理员账号并设置密码(test/test123)
* 集群：开启集群时,设置集群节点名ejabberd@xxx

##启动ejabberd
```
$ ./bin/ejabberdctl start
```

## web管理后台

为5280端口开启网路防火墙

```shell
$ vim /etc/sysconfig/iptables
$ /etc/init.d/iptables restart
```

访问地址：`http://ip:5280/admin` 输入管理员账号test,密码test123即可登录

[1]:https://www.process-one.net/en/ejabberd/downloads/

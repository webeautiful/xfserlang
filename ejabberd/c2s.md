#线上部署ejabberd之客户端测试

##下载客户端：[Spark 2.7.1][1]

##为客户端连接端口`5222`开启防火墙
```
vim /etc/sysconfig/iptables
service iptables restart
```

[1]: http://www.igniterealtime.org/projects/spark/

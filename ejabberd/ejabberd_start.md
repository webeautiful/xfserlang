ejabberd守护进程分析
===

`/opt/ejabberd-15.04/bin/epmd -daemon`

Erlang Port Mapper Daemon
epmd在Erlang集群中的作用相当于dns,完成Erlang节点和IP,端口的映射关系,,绑定在4369端口上

`/opt/ejabberd-15.04/bin/beam.smp -K true -P 250000 -- -root /opt/ejabberd-15.04 -progname /opt/ejabberd-15.04/bin/erl -- -home /root -- -sname ejabberd@rabbitmq2 -noshell -noinput -noshell -noinput -pa /opt/ejabberd-15.04/lib/ejabberd-15.04/ebin -mnesia dir "/opt/ejabberd-15.04/database/ejabberd@rabbitmq2" -ejabberd log_rate_limit 100 log_rotate_size 10485760 log_rotate_count 1 log_rotate_date "" -s ejabberd -sasl sasl_error_logger {file,"/opt/ejabberd-15.04/logs/erlang.log"} -smp auto start`

命令行参数:
* -K [true|false] 内核轮询
* -P 250000  Erlang进程的最大数量进程的最大数
* -root 指定ejabberd安装位置
* -progname 指定ejabberd执行程序位置
* -home /root 运行该程序linux账号的家目录
* -sname ejabberd@rabbitmq2 说明Ejabberd服务运行在本机Erlang节点ejabberd@rabbitmq2上
* -noshell
* -noinput 确保Erlang系统不尝试读任何输入. 运行守护进程和后台进程时有用
* -noshell
* -pa ../ebin 指定Erlang二进制文件(*.beam)所在目录.
* -mnesia dir "/opt/ejabberd-15.04/database/ejabberd@rabbitmq2" 指定Mnesia数据库位置
* -s ejabberd 通过`-s`指定应用的入口点
* -sasl sasl_error_logger {file,"/opt/ejabberd-15.04/logs/erlang.log"} Erlang/OTP系统日志文件的路径
* -smp [auto | true | false] SMP(多CPU)支持
* -remsh ejabberd@host  开启一个连接远程节点的Erlang shell

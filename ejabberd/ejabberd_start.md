ejabberd守护进程分析
===

`/opt/ejabberd-15.04/bin/epmd -daemon`

Erlang Port Mapper Daemon
epmd在Erlang集群中的作用相当于dns,完成Erlang节点和IP,端口的映射关系,,绑定在4369端口上

`/opt/ejabberd-15.04/bin/beam.smp -K true -P 250000 -- -root /opt/ejabberd-15.04 -progname /opt/ejabberd-15.04/bin/erl -- -home /root -- -sname ejabberd@rabbitmq2 -noshell -noinput -noshell -noinput -pa /opt/ejabberd-15.04/lib/ejabberd-15.04/ebin -mnesia dir "/opt/ejabberd-15.04/database/ejabberd@rabbitmq2" -ejabberd log_rate_limit 100 log_rotate_size 10485760 log_rotate_count 1 log_rotate_date "" -s ejabberd -sasl sasl_error_logger {file,"/opt/ejabberd-15.04/logs/erlang.log"} -smp auto start`

-sname ejabberd@rabbitmq2 说明Ejabberd服务运行在本机Erlang节点ejabberd上运行

文件编程
===
用于操作文件的模块归为四个模块

目录
---
+ [内容](#内容)
    - [file](#file)
    - [filename](#filename)
    - [filelib](#filelib)
    - [io](#io)

内容
---
### file
提供打开、读、写、关闭文件以及操作目录的基本方法

* [file模块源码][1]

```erlang
>file:get_cwd().
{ok,"/sdb/user_cikuu/xiongfs"}
```

### filename
提供平台独立方式，用于操纵文件名

* [filename模块源码][2]

```erlang
>filename:join(".", "a.erl").
"./a.erl"
>filename:join([".", "test", "a.erl"]).
"./test/a.erl"
```

### filelib
file模块的扩展，提供了更多的实用工具，在file模块基础上构建

* [filelib模块源码][3]

### io
一系列用于操作打开的文件的方法，解析格式、格式化输出等等

* [io模块源码][4]

######格式化输出命令
命令符|   说 明
------|---------------------------------
~f    |浮点数
~c    |ascii码
~s    |字符串
~w    |输出erlang term
~p    |输出erlang term, 以可打印格式输出
~n    |换行符


[1]: https://github.com/erlang/otp/blob/maint/lib/kernel/src/file.erl
[2]: https://github.com/erlang/otp/blob/maint/lib/stdlib/src/filename.erl
[3]: https://github.com/erlang/otp/blob/maint/lib/stdlib/src/filelib.erl
[4]: https://github.com/erlang/otp/blob/maint/lib/stdlib/src/io.erl

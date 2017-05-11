# DDNS_DNSPOD

用ruby写的域名和ip绑定的小工具


### 使用

- 首先你需要安装ruby环境
- ```git clone https://github.com/zcq100/ddns_dnspod.git```
- 执行 ```mv config.yaml.example config.yaml```
- 在config.yaml中设置id、token 和 要绑定的域名
- 执行 ```rake update``` 


你可以把```rake update```加到cron或者systemd-job里面定时执行。


```
=>rake -T
rake check   # Check domain change
rake info    # Info
rake ip      # Show local IP
rake list    # Get domain infomantion
rake update  # Update domain
```

Email:m@zcq100.com

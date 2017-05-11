# DDNS_DNSPOD
## Rakefile

在config.yaml里面设置id，token和要绑定的域名

然后执行 ```rake update```
可以把这个加到cron里面定时执行。


```
=>rake -T
rake check   # Check domain change
rake create  # Create record
rake delete  # Delete record
rake info    # info
rake ip      # Show local IP
rake list    # get all domain infomantion
rake update  # Update domain bind IP

```


* Email:m@zcq100.com

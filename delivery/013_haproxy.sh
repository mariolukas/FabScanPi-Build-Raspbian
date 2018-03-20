#!/bin/bash

BannerEcho "Haproxy: Installing"

AptInstall haproxy || return 1

echo "global
        maxconn 4096
        user haproxy
        group haproxy
        daemon
        log 127.0.0.1 local0 debug

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        retries 3
        option redispatch
        option http-server-close
        option forwardfor
        maxconn 2000
        timeout connect 5s
        timeout client  15min
        timeout server  15min

frontend public
        bind *:80
        default_backend fabscanpi

backend fabscanpi
       server fabscanpi1 127.0.0.1:8080
       errorfile 503 /etc/haproxy/errors/503.http"  > /etc/haproxy/haproxy.cfg


echo "HTTP/1.0 503 Service Unavailable^M
Cache-Control: no-cache^M
Connection: close^M
Content-Type: text/html^M
^M
<html><body><h1>503 FabScanPi Server Unavailable</h1>
Sometimes the FabScan Pi Server needs some seconds to start. Wait a few seconds and try again. <br>
Otherwise check if the FabScanPi Server is running! 
</body></html>
" > /etc/haproxy/errors/503.http

BannerEcho "Haproxy: Done"

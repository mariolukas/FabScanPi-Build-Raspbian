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
        reqrep ^([^\ :]*)\ /(.*)     \1\ /\2
        option forwardfor
        server fabscanpi1 127.0.0.1:8080"  > /etc/haproxy/haproxy.cfg

BannerEcho "Haproxy: Done"

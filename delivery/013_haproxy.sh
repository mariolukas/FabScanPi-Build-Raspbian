#!/bin/bash

BannerEcho "Haproxy: Installing"



AptInstall haproxy ssl-cert|| return 1

make-ssl-cert generate-default-snakeoil --force-overwrite
cat /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/private/ssl-cert-snakeoil.key > /etc/ssl/snakeoil.pem

echo "global
        maxconn 4096
        user haproxy
        group haproxy
        log 127.0.0.1 local1 debug

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
        bind :::80 v4v6
        bind :::443 v4v6 ssl crt /etc/ssl/snakeoil.pem 
        option forwardfor except 127.0.0.1
        default_backend fabscanpi

backend fabscanpi
        acl needs_scheme req.hdr_cnt(X-Scheme) eq 0
        reqrep ^([^\ :]*)\ /(.*) \1\ /\2
        reqadd X-Scheme:\ https if needs_scheme { ssl_fc }
        reqadd X-Scheme:\ http if needs_scheme !{ ssl_fc }
        option forwardfor
        server fabscanpi1 127.0.0.1:8080
        errorfile 503 /etc/haproxy/errors/503-no-fabscanpi.http"  > /etc/haproxy/haproxy.cfg


echo "HTTP/1.0 503 Service Unavailable
Cache-Control: no-cache
Connection: close
Content-Type: text/html

<html>
    <head>
        <title>OctoPrint is currently not running</title>
        <style>
            body {
                margin: 0;
                font-family: \"Open Sans\", \"Helvetica Neue\", Helvetica, Arial, sans-serif;
                font-size: 14px;
                line-height: 20px;
                color: #333333;
                background-color: #ffffff;
            }

            code {
                font-family: Monaco,Menlo,Consolas,\"Courier New\",monospace;
                font-size: 12px;
                border-radius: 3px;
                padding: 2px 4px;
                color: #d14;
                white-space: nowrap;
                background-color: #f7f7f7;
                border: 1px solid #e1e1e8;
            }

            pre {
                font-family: Monaco,Menlo,Consolas,\"Courier New\",monospace;
                font-size: 12px;
                border-radius: 3px;
                padding: 2px 4px;
                white-space: nowrap;
                background-color: #f7f7f7;
                border: 1px solid #e1e1e8;
            }

            @media (max-width: 767px) {
                .wrapper {
                    padding: 20px;
                }
            }

            @media (min-width: 768px) {
                .wrapper {
                    position: absolute;
                    width: 750px;
                    height: 450px;
                    top: 50%;
                    left: 50%;
                    margin: -225px 0 0 -375px;
                }
            }

            h1 {
                line-height: 1.3;
            }
        </style>
    </head>
    <body>
        <div class=\"wrapper\">
            <h1>The FabScanPi server is currently not running</h1>

            <p>
                If you just started up your Raspberry Pi, please wait a couple of seconds, then
                try to refresh this page.
            </p>

            <p>
                If the issue persists, please log into your Raspberry Pi via SSH and check the following:
            </p>

            <ul>
                <li>
                    Verify that the process is running:
                    <code>ps -ef | grep -i fabscanpi | grep -i python</code> should show a
                    python process:
                    <pre>pi@octopi:~ $ ps -ef | grep -i fabscanpi | grep -i python<br>
root     14674     1 77 11:19 ?        00:00:02 /usr/bin/python /usr/bin/fabscanpi-serveri <br> --config=/etc/fabscanpi/default.config.json --settings=/etc/fabscanpi/defaul
t.settings.json <br> --logfile=/var/log/fabscanpi/fabscanpi.log</pre>
                </li>
                <li>
                    If it isn't, the question is why. Take a look into
                    <code>/var/log/fabscanpi/fabscanpi.log</code>, there might
                    be an error logged in there that helps to determine
                    what's wrong.
                </li>
                <li>
                    You might also want to try if you can restart the server
                    (if no obvious error is visible):
                    <code>sudo service fabscanpi restart</code>.
                </li>
            </ul>

            <p>
                If all that doesn't help to trouble shoot the issue, you can seek
                support on the <a href=\"https://fabscan.org\">FabScanPi Community Page</a>.
                Please provide your Browser version and FabScanPi version as well as your <code>fabscanpi.log</code> 
                and explain what you already tried and observed as detailed as possible.
            </p>
        </div>
    </body>
</html>
" > /etc/haproxy/errors/503-no-fabscanpi.http

BannerEcho "Haproxy: Done"

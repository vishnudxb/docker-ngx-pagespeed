FROM ubuntu:14.04

MAINTAINER Vishnu Nair <vishnu@vishnu-tech.com>

RUN apt-get update &&  apt-get install -y python python-dev software-properties-common build-essential zlib1g-dev curl libpcre3 libpcre3-dev libssl-dev unzip wget tar

ENV NPS_VERSION 1.9.32.3
ENV NGINX_VERSION 1.7.9


RUN mkdir -p /src &&  cd /src/ && wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip && unzip release-${NPS_VERSION}-beta.zip

RUN cd /src/ngx_pagespeed-release-${NPS_VERSION}-beta/ && wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz && tar -xzvf ${NPS_VERSION}.tar.gz

RUN cd /src && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && tar -xzvf nginx-${NGINX_VERSION}.tar.gz

RUN cd /src/nginx-${NGINX_VERSION}/ && ./configure --add-module=/src/ngx_pagespeed-release-${NPS_VERSION}-beta --prefix=/etc/nginx  --sbin-path=/usr/sbin/nginx  --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid  --lock-path=/var/run/nginx.lock  --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-http_gzip_static_module --with-http_stub_status_module  --with-http_ssl_module  --with-pcre  --with-file-aio  --with-http_realip_module --with-debug --with-ipv6  --with-http_spdy_module  --with-http_sub_module && make && make install

RUN mkdir -p /var/pagespeed/cache

COPY ./sites-enabled/default /etc/nginx/sites-enabled/default
COPY ./nginx.conf /etc/nginx/nginx.conf

COPY . /src

WORKDIR /src

EXPOSE 80 443

CMD nginx

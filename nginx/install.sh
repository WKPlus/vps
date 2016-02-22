#!/usr/bin/env bash

yum install -y pcre-devel

wget https://openresty.org/download/openresty-1.9.7.3.tar.gz

tar -zxvf openresty-1.9.7.3.tar.gz
cd openresty-1.9.7.3 && ./configure --with-luajit && make && make install

ln -s /usr/local/openresty/nginx/sbin/nginx /usr/sbin/nginx

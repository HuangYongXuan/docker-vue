FROM centos:latest
MAINTAINER 754060604@qq.com

RUN yum install -y wget gcc gcc-c++
RUN mkdir -p /usr/download/
RUN cd /usr/download/ && wget -c https://npm.taobao.org/mirrors/node/latest-v11.x/node-v11.0.0-linux-x64.tar.xz \
    && tar -xf node-v11.0.0-linux-x64.tar.xz \
    && ln -s /usr/download/node-v11.0.0-linux-x64/bin/node /usr/local/bin/node \
    && ln -s /usr/download/node-v11.0.0-linux-x64/bin/npm /usr/local/bin/npm \
    && node -v

RUN wget -c https://nginx.org/download/nginx-1.17.2.tar.gz
RUN tar -xf nginx-1.17.2.tar.gz
RUN yum -y install pcre-devel openssl openssl-devel
RUN cd nginx-1.17.2 && sh ./configure --prefix=/usr/local/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-pcre \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
     && make && make install

RUN groupadd nginx
RUN useradd -g nginx -M nginx -s /sbin/nologin

RUN yum install -y git
RUN mkdir -p /usr/git/repository \
    && cd /usr/git/repository \
    && git clone https://github.com/PanJiaChen/vue-element-admin.git \
    && ls -ln
RUN cd /usr/git/repository/vue-element-admin && npm install && npm build:prod
RUN mkdir -p /usr/www/public && cp /usr/git/repository/vue-element-admin /usr/www/public

RUN rm -rf /etc/nginx/nginx.conf
COPY ./nginx.conf /etc/nginx

WORKDIR /usr/www
EXPOSE 8000
VOLUME ["/usr/www"]

CMD nginx

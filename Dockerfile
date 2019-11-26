FROM centos:latest
MAINTAINER 754060604@qq.com

RUN yum install -y wget gcc gcc-c++ pcre-devel openssl openssl-devel git sudo automake autoconf libtool make \
    && mkdir -p /usr/download/ \
    && wget -c https://nginx.org/download/nginx-1.17.6.tar.gz \
    && tar -xf nginx-1.17.6.tar.gz \
    && cd nginx-1.17.6 && sh ./configure --prefix=/usr/local/nginx \
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
    && make && make install && groupadd nginx && useradd -g nginx -M nginx -s /sbin/nologin \
    && rm -rf nginx-1.17.6 && rm -rf nginx-1.17.6.tar.gz \
    && mkdir -p /usr/www/ \
    && rm -rf /etc/nginx/nginx.conf \
    && yum -y remove wget gcc gcc-c++ pcre-devel openssl openssl-devel git sudo automake autoconf libtool make && yum clean all
COPY ./nginx.conf /etc/nginx

WORKDIR /usr/www
EXPOSE 8000
VOLUME ["/usr/www"]

ENTRYPOINT nginx -g "daemon off;"

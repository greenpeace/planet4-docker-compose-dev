FROM nginx:1.13-alpine

ENV PLANET4_BASE_URL https://github.com/greenpeace/planet4-base

USER root

RUN apk update && apk add openssl
RUN mkdir /etc/nginx/ssl
COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx/site.conf /etc/nginx/conf.d/default.conf

ADD bin/entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
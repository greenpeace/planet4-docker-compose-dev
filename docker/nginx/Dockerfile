FROM nginx:1.13-alpine

ENV PLANET4_BASE_URL https://github.com/greenpeace/planet4-base

USER root

COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx/site.conf /etc/nginx/conf.d/default.conf

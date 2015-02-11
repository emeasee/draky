FROM nginx
MAINTAINER Mac Oosthuizen <mac@piment.digital>

RUN mv /etc/nginx/nginx.conf /tmp/nginx.conf && echo "daemon off;" > /etc/nginx/nginx.conf && cat /tmp/nginx.conf >> /etc/nginx/nginx.conf && rm /tmp/nginx.conf
RUN rm /etc/nginx/conf.d/default.conf
ADD site.conf /etc/nginx/conf.d/default.conf

ADD build/ /opt/site/

WORKDIR /opt/site

CMD ["/usr/sbin/nginx"]

EXPOSE 80


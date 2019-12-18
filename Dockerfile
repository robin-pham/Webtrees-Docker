FROM nginx:1.15

COPY vhost.conf /etc/nginx/conf.d/default.conf
ADD https://github.com/fisharebest/webtrees/releases/download/2.0.0/webtrees-2.0.0.zip /var/www/

RUN apt-get clean \
  && apt-get update \
  && apt-get install -y \
    spawn-fcgi \
    fcgiwrap \
    unzip \
  && sed -i 's/www-data/nginx/g' /etc/init.d/fcgiwrap \
  && chown nginx:nginx /etc/init.d/fcgiwrap \
  && sed -i 's/^http {$/http {\n    client_max_body_size 40M;/' /etc/nginx/nginx.conf \
  && cd /var/www \
  && unzip /var/www/webtrees-2.0.0.zip \
  && mv webtrees/* . \
  && chown -R www-data:www-data * \
  && rmdir webtrees \
  && rm webtrees-2.0.0.zip \
  && chmod a+rwx /var/www/data

CMD /etc/init.d/fcgiwrap start \
    && nginx -g 'daemon off;'

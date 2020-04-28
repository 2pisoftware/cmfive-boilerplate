FROM httpd:2.4.33-alpine
RUN apk update;
RUN apk upgrade;

# Copy apache vhost file to proxy php requests to php-fpm container
# COPY cmfive.conf /usr/local/apache2/conf/000-default.conf
RUN echo "Include /etc/apache2/cmfive.conf" >> /usr/local/apache2/conf/httpd.conf
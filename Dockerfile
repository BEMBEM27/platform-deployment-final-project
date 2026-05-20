FROM php:8.2-fpm
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libzip-dev \
    zip \
    libxml2-dev \
    nginx

RUN docker-php-ext-install pdo pdo_mysql zip

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /var/www/html/platform-deployment-final-project
COPY . /var/www/html

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install --no-interaction --prefer-dist --no-progress

RUN chown -R www-data:www-data /var/www/html \
    && chown -R www-data:www-data /var/lib/nginx \
    && chown -R www-data:www-data /var/log/nginx \
    && mkdir -p /var/cache/nginx /var/run \
    && chown -R www-data:www-data /var/cache/nginx /var/run

EXPOSE 8080

CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;' "]
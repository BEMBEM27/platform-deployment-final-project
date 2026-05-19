FROM php:8.2-fpm

# Install system dependencies ug Nginx
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libzip-dev \
    zip \
    libxml2-dev \
    nginx

# I-install ang PHP Extensions
RUN docker-php-ext-install pdo pdo_mysql zip

# I-copy ang imong gi-edit nga nginx.conf sa sulod sa container
COPY nginx.conf /etc/nginx/nginx.conf

# Set working directory sa /var/www/html
WORKDIR /var/www/html

# I-copy ang tibuok project files padulong sa container
COPY . /var/www/html

# I-install ang Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# I-run ang composer install para sa dependencies sa vendor folder
RUN if [ -f composer.json ]; then composer install --no-interaction --prefer-dist --no-progress; fi

# Hatagan og husto nga permission ang www-data user para sa tanang logs ug folders
RUN chown -R www-data:www-data /var/www/html \
    && chown -R www-data:www-data /var/lib/nginx \
    && chown -R www-data:www-data /var/log/nginx \
    && mkdir -p /var/cache/nginx /var/run \
    && chown -R www-data:www-data /var/cache/nginx /var/run

EXPOSE 8080

# Sigurohon nga modagan si nginx gamit ang husto nga user account
CMD php-fpm -D && nginx -g "daemon off;"
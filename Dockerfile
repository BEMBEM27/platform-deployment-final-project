FROM php:8.2-fpm

# Install system dependencies, PHP extensions, and Nginx
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        unzip \
        curl \
        libzip-dev \
        zip \
        libxml2-dev \
        nginx \
    && docker-php-ext-install -j$(nproc) pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# I-copy ang imong nginx.conf sa saktong folder sa container
COPY nginx.conf /etc/nginx/nginx.conf

# Usba ang Working Directory ngadto sa gipangita ni Nginx
WORKDIR /var/www/html

# I-copy ang tibuok mong project files padulong sa /var/www/html
COPY . /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies gamit ang saktong path
RUN if [ -f /var/www/html/composer.json ]; then composer install --no-interaction --prefer-dist --no-progress; fi

# Hatagan og saktong permissions ang www-data user
RUN chown -R www-data:www-data /var/www/html \
    && chown -R www-data:www-data /var/lib/nginx \
    && chown -R www-data:www-data /var/log/nginx

EXPOSE 8080

# Siguroha nga executeable ang imong entrypoint sa bag-ong path
RUN chmod +x /var/www/html/entrypoint.sh
CMD ["sh", "/var/www/html/entrypoint.sh"]
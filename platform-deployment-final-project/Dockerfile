# 1. Gamita ang PHP 8.2 FPM image
FROM php:8.2-fpm

# 2. I-install ang mga gikinahanglan nga system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    nginx \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# 3. I-install ang Composer (para sa PHP dependencies)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 4. Set sa working directory
WORKDIR /var/www/html

# 5. I-copy ang tanan nimong project files sa container
COPY . .

# 6. I-install ang PHP dependencies (optimized para sa production)
RUN composer install --no-dev --optimize-autoloader --no-interaction

RUN php bin/console doctrine:schema:update --force --env=prod
# 7. I-set ang sakto nga permissions para sa web server
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# 8. I-copy ang Nginx configuration
# Siguroha nga naa kay nginx.conf file sa imong root folder
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 9. I-setup ang entrypoint script (para sa pag-start sa nginx ug php-fpm)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 10. I-expose ang port 80
EXPOSE 80

# 11. I-run ang script pag-start
ENTRYPOINT ["/entrypoint.sh"]
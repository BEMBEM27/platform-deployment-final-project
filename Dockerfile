FROM php:8.2-fpm

# Install system dependencies and PHP extensions
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        unzip \
        curl \
        libzip-dev \
        zip \
        libxml2-dev \
    && docker-php-ext-install -j$(nproc) pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --version

# Set working directory
WORKDIR /var/www

# Copy project files
COPY . /var/www

# Install PHP dependencies if `composer.json` exists
RUN if [ -f /var/www/composer.json ]; then composer install --no-interaction --prefer-dist --no-progress; fi

# Fix permissions
RUN chown -R www-data:www-data /var/www

EXPOSE 9000

CMD ["php-fpm"]

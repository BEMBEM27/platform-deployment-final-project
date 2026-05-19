#!/bin/sh

# Run database migrations
php bin/console doctrine:migrations:migrate --no-interaction

# Start PHP-FPM in background
php-fpm -D

# I-start ang Nginx sa foreground aron magpabilin buhi ang container
nginx -g "daemon off;"
#!/bin/sh
set -e
cd /var/www/html

if [ "$APP_ENV" = "prod" ]; then
    php bin/console cache:clear --env=prod --no-warmup
    php bin/console cache:warmup --env=prod --no-debug
fi

# Patuyukon ang database migration
php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration

# Sugdan ang PHP-FPM sa background ug i-foreground si Nginx
php-fpm -D
nginx -g "daemon off;"
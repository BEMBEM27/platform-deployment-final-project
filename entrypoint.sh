#!/bin/sh
set -e

if [ "$APP_ENV" = "prod" ]; then
    php bin/console cache:clear --env=prod --no-warmup
    php bin/console cache:warmup --env=prod --no-debug
fi

composer install --no-dev --optimize-autoloader --no-interaction

php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration

php-fpm -D
nginx -g "daemon off;"
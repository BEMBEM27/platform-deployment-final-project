#!/bin/bash
set -e

echo "=== Symfony Entrypoint Starting ==="

# 1. Wait for database to be ready
echo "Waiting for database connection..."
until php -r "new PDO('mysql:host=${DB_HOST:-db};dbname=${MYSQL_DATABASE:-symfony}', '${MYSQL_USER:-root}', '${MYSQL_PASSWORD:-secret}');" 2>/dev/null; do
  echo "Database not ready yet, retrying in 2s..."
  sleep 2
done
echo "Database connection established."

# 2. Clear and warm up Symfony cache
echo "Clearing and warming up Symfony cache..."
php bin/console cache:clear --env=prod
php bin/console cache:warmup --env=prod

# 3. Run database migrations
echo "Running database migrations..."
php bin/console doctrine:migrations:migrate --no-interaction --env=prod

# 4. Fix permissions
chown -R www-data:www-data /var/www/html/var
chmod -R 775 /var/www/html/var

echo "=== Entrypoint complete. Starting services... ==="

# 5. Start both services
# PHP-FPM gipadagan sa background (-D)
php-fpm -D

# Nginx gipadagan sa foreground (kinahanglan ni para dili mamatay ang container)
exec nginx -g "daemon off;"
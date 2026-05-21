#!/bin/bash
set -e

echo "=== Symfony Entrypoint Starting ==="

# Wait for database to be ready
echo "Waiting for database connection..."
until php -r "new PDO('mysql:host=${DB_HOST:-db};dbname=${MYSQL_DATABASE:-symfony}', '${MYSQL_USER:-root}', '${MYSQL_PASSWORD:-secret}');" 2>/dev/null; do
  echo "Database not ready yet, retrying in 2s..."
  sleep 2
done
echo "Database connection established."

# Clear and warm up Symfony cache
echo "Clearing Symfony cache..."
php bin/console cache:clear --env=prod --no-warmup
php bin/console cache:warmup --env=prod

# Run database migrations
echo "Running database migrations..."
php bin/console doctrine:migrations:migrate --no-interaction --env=prod || true

# Fix permissions
chown -R www-data:www-data /var/www/html/var
chmod -R 775 /var/www/html/var

echo "=== Entrypoint complete. Starting PHP-FPM... ==="

# Start PHP-FPM
exec "$@"
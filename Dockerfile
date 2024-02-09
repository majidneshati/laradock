FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev \
    default-mysql-client  \
    curl  \
    gnupg  \
    procps  \
    vim  \
    libzip-dev  \
    libpq-dev \
    git \
    unzip \
    tzdata \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath zip gd ftp

# Install redis
RUN pecl install -o -f redis
RUN docker-php-ext-enable redis

# Copy the local application directory to the container
COPY . /var/www/backend

WORKDIR /var/www/backend

RUN chown -R www-data:www-data /var/www/backend \
    && chmod -R 775 /var/www/backend/storage

# install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN composer install

# Set permissions for the storage and cache directories
RUN chown -R www-data:www-data /var/www/backend /var/www/backend/storage /var/www/backend/bootstrap/cache
#RUN chmod -R 775 /var/www/storage /var/www/backend/bootstrap/cache

# # RUN composer install --prefer-dist --no-interaction
# ENV COMPOSER_ALLOW_SUPERUSER=1
# RUN composer install --prefer-dist --no-dev --optimize-autoloader --no-interaction

# USER $user

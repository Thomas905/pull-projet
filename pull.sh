#!/bin/bash

# Extract database information from .env.local
database_url=$(grep "DATABASE_URL" .env.local | sed 's/DATABASE_URL="//; s/"$//')

# Parse the database URL to get user, password, host, and database name
db_user=$(echo $database_url | sed -E 's/.*:\/\/([^:]+):([^@]+)@([^:]+):.*/\1/')
db_password=$(echo $database_url | sed -E 's/.*:\/\/([^:]+):([^@]+)@([^:]+):.*/\2/')
db_host=$(echo $database_url | sed -E 's/.*:\/\/([^:]+):([^@]+)@([^:]+):.*/\3/')
db_name=$(echo $database_url | sed -E 's/.*\/(.*)\?.*/\1/')

# Backup SQL
mysqldump -u "$db_user" -p"$db_password" -h "$db_host" "$db_name" > backup.sql

# Restore git
git restore .

# Pull from git
git pull

# Compile WebPack
yarn encore dev

# Doctrine migration
bin/console d:m:m

# Clear cache
bin/console cache:clear

# Permission 777
chmod -R 777 *

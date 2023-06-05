#!/bin/bash

# Restore git
git restore .

# Pull from git
git pull

# Compile WebPack
yarn encore dev

# Clear cache
bin/console cache:clear

# Permission 777
chmod -R 777 *
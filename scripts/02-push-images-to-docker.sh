#!/usr/bin/env bash

set -euo pipefail

script_dir=$(dirname "$0")

# script variables
backend_image='daniellindemann/beer-rating-backend'
frontend_image='daniellindemann/beer-rating-frontend'
console_image='daniellindemann/beer-rating-console-beerquotes'
migrations_image='daniellindemann/beer-rating-backend-migrations'

# push the images to docker hub
images=(
    "${backend_image}"
    "${frontend_image}"
    "${console_image}"
    "${migrations_image}"
)

for image in "${images[@]}"; do
    docker push -a "${image}:${tag}"
done

echo "All images pushed to Docker Hub."

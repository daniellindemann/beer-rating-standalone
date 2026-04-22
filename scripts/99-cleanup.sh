#!/usr/bin/env bash

set -euo pipefail

script_dir=$(dirname "$0")

# script variables
image_search_strings=(
    'beer-rating-frontend'
    'beer-rating-backend'
    'beer-rating-console-beerquotes'
    'beer-rating-backend-migrations'
)

# find and delete all docker images containing any of the image_search_strings
for search_string in "${image_search_strings[@]}"; do
  echo "Removing Docker images matching '${search_string}'..."
  docker images --format '{{.Repository}} {{.ID}}' | grep "${search_string}" | awk '{print $2}' | sort -u | xargs --no-run-if-empty docker rmi --force
done

echo "Cleanup completed."

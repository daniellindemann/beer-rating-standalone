#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
# Treat unset variables as an error and exit
# Return the exit status of the last command in a pipeline that failed
set -euo pipefail

script_dir=$(dirname "$0")

# ensure docker builder with arm64 support is available
ensure_docker_buildx_builder() {
    builderName='mybuilder'

    if ! command -v docker &> /dev/null; then
        echo "Docker CLI not found, skipping buildx builder setup"
        return
    fi

    if ! docker buildx version &> /dev/null; then
        echo "Docker buildx is not available, skipping builder setup"
        return
    fi

    if docker buildx ls --format '{{.Name}}' | grep -qx "$builderName"; then
        echo "Docker buildx builder '${builderName}' already exists"
        docker buildx use $builderName
        return
    fi

    echo "Docker buildx builder '${builderName}' not found. Creating it"
    docker buildx create --name "${builderName}" --use --bootstrap --platform linux/amd64,linux/arm64
}
ensure_docker_buildx_builder


# ensure temp directory exists
ensure_temp_dir() {
    if [ ! -d "$script_dir/.temp" ]; then
        mkdir -p "$script_dir/.temp"
    fi
}

# ensure permissions in home directory
sudo chown -R "$(whoami)" "$HOME"

# update dotnet workloads
sudo dotnet workload update

# install dotnet tools
dotnet tool restore

# restore and build projects
dotnet restore && dotnet build --no-restore

echo "✅ Post-create command completed successfully."

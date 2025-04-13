#!/usr/bin/env bash

# Default values
BASE_IMAGE="debian:bookworm"
IMAGE_TAG="$BASE_IMAGE-zsh"

# Function to display help
function display_help() {
    printf "\n\033[1mUsage:\033[0m %s [OPTIONS] [DOCKER_BUILD_ARGS]\n\n" "$0"
    printf "\033[1mOptions:\033[0m\n"
    printf "  \033[36m%-20s\033[0m %s\n" "-b, --base-image" "Set the base image (default: bookworm)"
    printf "  \033[36m%-20s\033[0m %s\n" "-t, --tag"         "Docker image tag (default: debian:bookworm-zsh)"
    printf "  \033[36m%-20s\033[0m %s\n" "-h, --help"        "Display this help message"
    printf "\n\033[1mDOCKER_BUILD_ARGS:\033[0m\n"
    printf "  Any additional arguments will be passed directly to the 'docker build' command.\n\n"
    printf "\033[1mDocker Build Help:\033[0m\n"
    docker build --help
    exit 0
}

docker_image_info() {
    local tag="$1"
    printf "\033[32m✅ Build completed successfully.\033[0m\n"

    local id=$(docker images -q $IMAGE_TAG)
    local arch=$(docker inspect --format '{{.Architecture}}' "$tag")
    local os=$(docker inspect --format '{{.Os}}' "$tag")
    local size=$(docker inspect --format '{{.Size}}' "$tag")
    local created=$(docker inspect --format '{{.Created}}' "$tag")

    # Convert bytes to human-readable size
    function human_size() {
        local bytes=$1
        local unit=("B" "KB" "MB" "GB" "TB")
        local i=0
        while [[ $bytes -ge 1024 && $i -lt 4 ]]; do
            bytes=$((bytes / 1024))
            ((i++))
        done
        echo "${bytes} ${unit[$i]}"
    }

    local size_hr=$(human_size "$size")
    
    label_width=14
    printf "\033[34m%-${label_width}s:\033[0m %s\n" "Docker Image" "$tag"
    printf "\033[34m%-${label_width}s:\033[0m %s\n" "Image ID" "$id"
    printf "\033[34m%-${label_width}s:\033[0m %s\n" "Architecture" "$arch"
    printf "\033[34m%-${label_width}s:\033[0m %s\n" "OS" "$os"
    printf "\033[34m%-${label_width}s:\033[0m %s bytes\n" "Size" "$size_hr"
    printf "\033[34m%-${label_width}s:\033[0m %s\n" "Created" "$created"
}

# Parse command-line options
DOCKER_BUILD_ARGS=()
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -b|--base-image) BASE_IMAGE="$2"; shift ;;
        -t|--tag) IMAGE_TAG="$2"; shift ;;
        -h|--help) display_help ;;
        *) DOCKER_BUILD_ARGS+=("$1") ;; # Collect all other arguments
    esac
    shift
done

printf "\033[34m🔧 Preparing to build Docker image...\033[0m\n"
printf "\033[33m📋 Command:\033[0m %s\n" "docker build -t \"$IMAGE_TAG\" --build-arg \"BASE_IMAGE=$BASE_IMAGE\" \"${DOCKER_BUILD_ARGS[@]}\" ."

# Build the Docker image
docker build -t "$IMAGE_TAG" --build-arg "BASE_IMAGE=$BASE_IMAGE" "${DOCKER_BUILD_ARGS[@]}" .

# Check if the build was successful
if [ $? -eq 0 ]; then
    docker_image_info "$IMAGE_TAG"
else
    printf "\033[31m❌ Failed to build Docker image: %s.\033[0m\n" "$IMAGE_TAG"
    exit 1
fi

#!/usr/bin/env bash

BASE_IMAGE="debian:bookworm"
IMAGE_TAG="$BASE_IMAGE-ohmyzsh"

bash ../base-build.sh --base-image "$BASE_IMAGE" -t "$IMAGE_TAG" "$@"

#!/usr/bin/env bash

BASE_TAG="${1:-bookworm}"
IMAGE_NAME="${2:-debian}"
IMAGE_TAG="${3:-$BASE_TAG-zsh}"

docker build --build-arg BASE_TAG=$BASE_TAG -t $IMAGE_NAME:$IMAGE_TAG --platform linux/amd64 .

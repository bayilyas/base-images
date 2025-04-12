#!/usr/bin/env bash

docker build --build-arg BASE_TAG=bookworm -t debian:bookworm-zsh .

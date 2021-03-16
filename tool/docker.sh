#!/bin/sh

set -e

docker build -f Dockerfile_build -t glesica/dcdg_build:latest .
docker push glesica/dcdg_build:latest

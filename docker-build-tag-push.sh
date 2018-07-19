#!/usr/bin/env bash
set -e
if [ ! -z ${DEBUG:+X} ]; then
  set -x;
fi

NAME=ouzklcn/rancher-reaper

DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

build() {
  docker build --tag ${NAME} ${DIR}
}

tag() {
  for TAG in "$@"; do
    docker tag ${NAME} ${NAME}:${TAG}
  done
}

push() {
  docker push ${NAME}
}

build

if [ ${CI:-false} == 'true' ]; then
  tag ci
else
  tag local
fi

if [ ! -z ${TRAVIS_TAG:+X} ]; then
  tag ${TRAVIS_TAG}
fi

push

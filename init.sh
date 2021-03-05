#!/bin/bash

cd "$(dirname "$0")" || exit 1

mkdir -p var/run var/log/supervisor var/minio var/cache

[ -f var/run/supervisord.pid ] && kill "$(cat var/run/supervisord.pid)"
supervisord --nodaemon --directory ./ --configuration ./supervisord.conf


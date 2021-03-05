#!/bin/bash

cd "$(dirname "$0")" || exit 1

mkdir -p var/run var/log/supervisor minio-data

[ -f var/run/supervisord.pid ] && kill "$(cat var/run/supervisord.pid)"
supervisord --nodaemon --directory ./ --configuration ./supervisord.conf


#!/bin/bash

function build() {
  echo building ... >/dev/stderr
  find /nix/store/ -mindepth 1 -maxdepth 1 -type d | shuf | head -1
}
function push() {
  S3_BUCKET=nix
  S3_PROFILE=default
  S3_SCHEME=http
  S3_ENDPOINT=127.0.0.1:9000
  S3_URL="s3://$S3_BUCKET?profile=$S3_PROFILE&scheme=$S3_SCHEME&endpoint=$S3_ENDPOINT"
  while read -r P; do
    echo "=== pushing $P ..."
    nix copy -v "$P" --to "$S3_URL"
  done
}

while true; do
  echo sleep..; sleep 60
  build | push
done
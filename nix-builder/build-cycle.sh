#!/bin/bash

function take-one() {
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

cd "$(dirname "$0")" || exit 1
while true; do
  sleep 15
  # take-one | push
  for D in app*; do
    (
      echo -n "*** building $D - "
      cd $D || exit 1
      nix path-info --all > /tmp/store-path-pre-build-$D
      nix-build
      #nix-build | push
      comm -13 \
        <(sort /tmp/store-path-pre-build-$D | grep -v '\.drv$') \
        <(nix path-info --all | grep -v '\.drv$' | sort) \
          | push

      rm -f result
    )
  done
done
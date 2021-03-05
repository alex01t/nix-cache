#!/bin/bash

cd "$(dirname "$0")" || exit 1
while true; do
  sleep 1
  for D in app*; do
    (
      echo -n "--- fetching $D - "
      cd $D || exit 1
      timeout  --signal=9  3  nix-build \
        --option require-sigs false \
        --option binary-caches http://198.18.0.2:8080/nix/
      rm -f result
    )
  done
done

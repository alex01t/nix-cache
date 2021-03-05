#!/bin/bash
shopt -s expand_aliases
alias aws='aws --endpoint-url http://127.0.0.1:9000'

mc alias set s3 http://127.0.0.1:9000 minioadmin minioadmin;
mc mb s3/nix;
mc policy set public s3/nix;

echo "`date` - oh-hi.." | aws s3 cp - s3://nix/hello
aws s3 ls s3://nix/

echo
curl http://127.0.0.1:9000/nix/hello

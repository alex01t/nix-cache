FROM nixos/nix
RUN nix-env -i nix-serve nginx curl jq
CMD nix-serve
EXPOSE 5000
EXPOSE 8000

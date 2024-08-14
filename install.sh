#!/usr/bin/env bash

nix-shell -p git --command "nix run --experimental-features 'nix-command flakes' gitlab:librephoenix/nixos-config"

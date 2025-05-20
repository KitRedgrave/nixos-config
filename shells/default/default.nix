{ lib, pkgs, ... }:

with pkgs;
mkShell { packages = [ sops ssh-to-age nixos-anywhere nixos-rebuild nixd ]; }

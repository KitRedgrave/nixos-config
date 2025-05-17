{ lib, pkgs, ... }:

with pkgs;
mkShell { packages = [ sops nixos-anywhere nixos-rebuild nixd ]; }

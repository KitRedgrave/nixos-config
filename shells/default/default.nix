{ lib, pkgs, ... }:

with pkgs;
mkShell { packages = [ sops nixd ]; }

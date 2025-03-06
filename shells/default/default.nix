{ lib, pkgs, ... }:

with pkgs;
mkShell { packages = [ nixd ]; }

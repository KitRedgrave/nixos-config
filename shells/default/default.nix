{ lib, pkgs, ... }:

with pkgs;
mkShell {
  packages = [ sops ssh-to-age git-agecrypt nixos-anywhere nixos-rebuild nixd ];
}

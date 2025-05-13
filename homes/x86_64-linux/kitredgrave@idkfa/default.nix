{ config, lib, pkgs, ... }:

{
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git.enable = true;
    ssh.enable = true;
  };
}

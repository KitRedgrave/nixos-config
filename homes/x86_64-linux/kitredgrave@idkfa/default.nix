{ config, lib, pkgs, ... }:

{
  sops.defaultSopsFile = ./secrets.yaml;
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git.enable = true;
    ssh.enable = true;
  };

  home.stateVersion = "24.05";
}

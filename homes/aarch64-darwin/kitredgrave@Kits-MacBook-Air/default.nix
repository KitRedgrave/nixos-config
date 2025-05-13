{ config, lib, pkgs, namespace, ... }:

{
  home.stateVersion = "23.05";
  home.packages = [
    pkgs.fd
    pkgs.ripgrep
    pkgs.wget
    pkgs.yubikey-personalization
    pkgs.nixfmt-classic
    pkgs.openssh
  ];
  home.sessionPath = [ "/opt/homebrew/bin" ];
  home.sessionVariables.EDITOR =
    "${pkgs.local.emacs30-homebrew}/bin/emacsclient";
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    emacs = {
      enable = true;
      package = pkgs.local.emacs30-homebrew;
      extraPackages = epkgs: [ epkgs.vterm ];
    };
    git.enable = true;
    gpg = {
      enable = true;
      settings = { use-agent = true; };
    };
    password-store = {
      enable = true;
      settings.PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
    nix-index.enable = true;
    ssh.enable = true;
    zsh = {
      enable = true;
      plugins = [{
        name = "emacs-vterm";
        file = "etc/emacs-vterm-zsh.sh";
        src = fetchGit {
          url = "https://github.com/akermu/emacs-libvterm";
          rev = "576408473b655491cfc85b1124456504d35d73a3";
        };
      }];
    };
  };
}

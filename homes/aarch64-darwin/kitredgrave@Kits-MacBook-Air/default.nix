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
        name = "emacs-eat";
        file = "integration/zsh";
        src = fetchGit {
          url = "https://codeberg.org/akib/emacs-eat";
          rev = "b2ad1be4113f1e1716d2723cab509bb7b8d24105";
        };
      }];
    };
  };
}

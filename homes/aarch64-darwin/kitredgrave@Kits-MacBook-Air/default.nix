{ config, lib, pkgs, namespace, ... }:

{
  home.stateVersion = "23.05";
  home.packages = [
    pkgs.wget
    pkgs.yubikey-personalization
    pkgs.fzf
    pkgs.ripgrep
    pkgs.nixfmt-classic
    pkgs.openssh
    pkgs.dockfmt
    pkgs.editorconfig-checker
    pkgs.nodejs
    pkgs.cljfmt
    pkgs.sbcl
    pkgs.discount
    pkgs.pngpaste
    pkgs.graphviz
    pkgs.shfmt
    pkgs.shellcheck
    pkgs.stylelint
    pkgs.jsbeautifier
  ];
  home.sessionPath = [ "/opt/homebrew/bin" ];
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    doom-emacs = {
      doomDir = "/Users/kitredgrave/.config/doom";
      emacs = pkgs.local.emacs30-homebrew;
      enable = true;
      experimentalFetchTree = true;
      extraPackages = epkgs: [ epkgs.vterm ];
      tangleArgs = "--all config.org";
    };
    git.enable = true;
    gpg.enable = true;
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
          rev = "056ad74653704bc353d8ec8ab52ac75267b7d373";
        };
      }];
    };
  };
  services = {
    emacs = {
      client.enable = true;
      defaultEditor = true;
      enable = true;
    };
    gpg-agent = {
      enable = true;
      enableScDaemon = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry_mac;
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
    };
  };
}

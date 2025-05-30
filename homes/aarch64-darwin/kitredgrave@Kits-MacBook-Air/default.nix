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
          rev = "056ad74653704bc353d8ec8ab52ac75267b7d373";
        };
      }];
    };
  };
  services = {
    emacs = {
      client.enable = true;
      defaultEditor = true;
      package = pkgs.local.emacs30-homebrew;
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

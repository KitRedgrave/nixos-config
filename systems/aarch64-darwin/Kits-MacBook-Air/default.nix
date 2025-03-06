{ pkgs, ... }:

{
  nix = {
    settings = { trusted-users = [ "kitredgrave" ]; };
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    linux-builder = {
      enable = true;
      ephemeral = true;
    };
  };

  users.users.kitredgrave = {
    name = "kitredgrave";
    home = "/Users/kitredgrave";
  };

  services.tailscale.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  programs.gnupg = {
    agent.enable = true;
    agent.enableSSHSupport = true;
  };

  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    dock.persistent-apps = [
      "/System/Applications/Launchpad.app"
      "/System/Applications/Mail.app"
      "/System/Applications/Calendar.app"
      "/Applications/Firefox.app"
      "/Applications/Discord.app"
      "${pkgs.local.emacs30-homebrew}/Applications/Emacs.app"
    ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

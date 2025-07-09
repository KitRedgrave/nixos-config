{ pkgs, ... }:

{
  nix-rosetta-builder = {
    enable = true;
    onDemand = true;
    diskSize = "10GiB";
  };
  nix = {
    settings.max-jobs = 4;
    settings.trusted-users = [ "kitredgrave" ];
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  users.users.kitredgrave = {
    name = "kitredgrave";
    home = "/Users/kitredgrave";
  };

  system.primaryUser = "kitredgrave";

  services.tailscale.enable = true;
  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    dock.persistent-apps = [
      "/System/Applications/Launchpad.app"
      "/System/Applications/Mail.app"
      "/System/Applications/Calendar.app"
      "/Applications/Firefox.app"
      "/Applications/Discord.app"
    ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

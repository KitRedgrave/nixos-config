{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # imports = [ ./disko.nix ];
  #boot.loader.grub.enable = true;
  #networking.hostname = "steamdeck";
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  time.timeZone = "America/Los_Angeles";
  users.users.kitredgrave = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  services = {
    openssh.enable = true;
    tailscale.enable = true;
    xserver.enable = true;
    desktopManager.plasma6.enable = true;
  };
  jovian.devices.steamdeck.enable = true;
  jovian.steam = {
    enable = true;
    desktopSession = "plasma";
    autoStart = true;
    user = "kitredgrave";
  };
  system.stateVersion = "24.05";
}

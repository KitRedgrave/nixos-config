{ config, lib, pkgs, ... }:

{
  #deployment = { targetHost = "idkfa.kitredgrave.net"; };

  #boot.loader.grub.enable = true;
  #boot.loader.grub.devices = [ "/dev/sda" ];

  networking.hostName = "idkfa";

  services.tailscale.enable = true;

  time.timeZone = "America/Los_Angeles";

  system.stateVersion = "24.05";
}

{ config, lib, pkgs, ... }:

{
  disko.devices = { disk = { vda = { device = "/dev/disk/by-id/??"; }; }; };
}

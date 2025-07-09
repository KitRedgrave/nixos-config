{ config, lib, pkgs, inputs, ... }:

{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      luks-zfs-passphrase = { };
      luks-zfs-keyfile = {
        format = "binary";
        sopsFile = ./luks-zfs-keyfile.enc;
      };
      tailscale-key = { };
      wifi-key = {
        format = "binary";
        sopsFile = inputs.self + "/secrets/home-wifi.enc";
      };
    };
  };
}

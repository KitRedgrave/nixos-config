{ config, lib, inputs, pkgs, systems, ... }:

{
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets = {
    ssh_host_ed25519_key = {
      format = "binary";
      sopsFile = ./ssh_host_ed25519_key.enc;
    };
    wifi-key = {
      format = "binary";
      sopsFile = inputs.self + "/secrets/home-wifi.enc";
    };
  };
  networking.wireless = {
    enable = true;
    secretsFile = config.sops.secrets.wifi-key.path;
    networks."Temp Wifi".pskRaw = "ext:psk_home";
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFnTd9ZbGfMbH13K3bsBAJLZeTGxvnBbeLICaW5+hfmCAAAABHNzaDo= kitredgrave@Kits-MacBook-Air.local"
  ];
  services.openssh = {
    enable = true;
    hostKeys = [ ]; # manually defined below, nixos only generates new
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };
  environment.etc = {
    "ssh/ssh_host_ed25519_key".source =
      config.sops.secrets.ssh_host_ed25519_key.path;
    "ssh/ssh_host_ed25519_key.pub".source = ./ssh_host_ed25519_key.pub;
  };
}

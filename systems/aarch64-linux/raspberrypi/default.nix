{ lib, pkgs, inputs, config, ... }:

{
  # workaround for https://github.com/nix-community/nixos-generators/issues/266
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  sops.secrets = {
    tailscale-key = {
      format = "binary";
      sopsFile = ./tailscale.enc;
    };
    wifi-key = {
      format = "binary";
      sopsFile = ./wifi.enc;
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking = {
    firewall.enable = false;
    hostName = "raspberrypi";
    hosts = { "10.0.0.1" = [ "raspberrypi.desknet" ]; };
    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.wifi-key.path;
      networks."Temp Wifi".pskRaw = "ext:psk_home";
    };
    interfaces.wlan0.useDHCP = true;
    interfaces.end0 = {
      useDHCP = false;
      ipv4 = {
        addresses = [{
          address = "10.0.0.1";
          prefixLength = 24;
        }];
        routes = [{
          address = "10.0.0.0";
          prefixLength = 24;
          via = "10.0.0.1";
        }];
      };
    };
    nameservers = [ "127.0.0.1" ];
  };

  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    settings = {
      listen-address = [ "127.0.0.1" "10.0.0.1" ];
      local = "/desknet/";
      domain = "desknet";
      server = [ "9.9.9.9" ];
      domain-needed = true;
      bogus-priv = true;
      dhcp-range = [ "10.0.0.2,10.0.0.254" ];
      dhcp-option = "121,10.0.0.0/24,10.0.0.1";
    };
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets.tailscale-key.path;
  };

  services.sshd.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1u57T9mio+04M7qU0ERvd0Kz1jN7RCxleVe141HcGeoToWVwDZjxcIzmfLBKCaSkOOT9IyWpzmsj7OH+1oOiCq9oa6PCxh//FWeTSb5Jjnpu8Lu8AsMnqZ3vMpfGliHoi/5l3CTS1ai7Pepvy1R7m0l1DQUoJk8+bcsg5ErmjLA2l2wNRtsAC/vqrtE8qtPq3UNtKSTcA+iQD7SIrvSxUJJ8ZKLSSQlTtjstC18+C2sMk45DQyw3iV1e93UJVX1UpJxog4KOgt4vfhRZkngs22f6AUbTn+3r7vtYOBaJJp3VytcSwT+srpsSAzwnDiz20qpfKqchXC3LoDWWGrSOOc8+KMFxWw2COIcFK4JBOfvZWftFBT6HjKgPIywjG4L9eVu03TSG8CFMAbb/mWeqN9yFUlBt5dcMhDA0L3bx69X/i90tE4h7ajH6IRFDlfWWRPt4X1TwbMzLW10fZhPt8mqK5a2rnIGtIJm3TAdt2Aokq6Iw1pvFNY9/6E2IG1B2sw3hyqi9jHM52hFZAncUBmF6TWO0tvpvr4XDt8pomvpxbIob2ypd5xjsLYNI3VA27nM6IsFqR+X5ncElkmKLDbqagX81vcxINho5FmljNt51aIKbxMjJZ3KYq2aR0KzEYqnaWiht0VYPwoqSZIXynurrSDOATDuh0CQH+Ggjjfw== cardno:24_736_654"
  ];

  systemd.services.usb-ethernet-gadget = {
    enable = false;
    wantedBy = [ "sysinit.target" ];
    script = ''
      mkdir -p /sys/kernel/config/usb_gadget/mygadget
      cd /sys/kernel/config/usb_gadget/mygadget
      echo 0x1d6b > idVendor
      echo 0x0104 > idProduct
      echo 0x0100 > bcdDevice
      echo 0x0200 > bcdUSB
      mkdir -p strings/0x409
      echo "1234567890" > strings/0x409/serialnumber
      echo "me" > strings/0x409/manufacturer
      echo "My USB Device" > strings/0x409/product
      mkdir -p configs/c.1/strings/0x409
      echo "Config 1: NCM network" > configs/c.1/strings/0x409/configuration
      echo 250 > configs/c.1/MaxPower
      mkdir -p functions/ncm.usb0
      echo "12:22:33:44:55:66" > functions/ncm.usb0/host_addr
      echo "16:22:33:44:55:66" > functions/ncm.usb0/dev_addr
      ln -s functions/ncm.usb0 configs/c.1/
      mkdir -p functions/acm.asb0
      ln -s functions/acm.usb0 configs/c.1/
      ls /sys/class/udc > UDC
    '';
  };
  systemd.services."serial-getty@ttyGS0" = {
    enable = false;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };

  system.stateVersion = "24.05";
}

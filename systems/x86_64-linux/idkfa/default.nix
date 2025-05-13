{ config, lib, pkgs, inputs, ... }:

{
  boot.initrd = {
    availableKernelModules = [ "ahci" "xhci_pci" "nvme" "usbhid" ];
    kernelModules = [ ];
  };
  boot.kernelModules = [ "kvm-amd" ];
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  sops.secrets = {
    tailscale-key = {
      format = "binary";
      sopsFile = ./tailscale.enc;
    };
    wifi-key = {
      format = "binary";
      sopsFile = inputs.self + "/secrets/home-wifi.enc";
    };
    luks-zfs-keyfile = {
      format = "binary";
      sopsFile = ./luks_zfs_keyfile.enc;
    };
  };

  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            MBR = {
              type = "EF02";
              size = "1M";
              priority = 1;
            };
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
      disk1 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:01:00.0-ata-1";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "disk1_crypt";
                settings = {
                  keyFile = "/boot/keyfile";
                  allowDiscards = true;
                };
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };
      disk2 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:01:00.0-ata-2";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "disk2_crypt";
                settings = {
                  keyFile = "/boot/keyfile";
                  allowDiscards = true;
                };
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };
      disk3 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:01:00.0-ata-3";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "disk3_crypt";
                settings = {
                  keyFile = "/boot/keyfile";
                  allowDiscards = true;
                };
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };
      disk4 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:01:00.0-ata-4";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "disk4_crypt";
                settings = {
                  keyFile = "/boot/keyfile";
                  allowDiscards = true;
                };
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };
      disk5 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:01:00.0-ata-5";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "disk5_crypt";
                settings = {
                  keyFile = "/boot/keyfile";
                  allowDiscards = true;
                };
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };
    };
    zpool = {
      tank = {
        type = "zpool";
        mode = "raidz1";
        rootFsOptions = { compression = "lz4"; };
        mountpoint = "/tank";
      };
    };
  };
  snowfallorg.users.kitredgrave = {
    create = true;
    admin = true;
    home.enable = true;
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1u57T9mio+04M7qU0ERvd0Kz1jN7RCxleVe141HcGeoToWVwDZjxcIzmfLBKCaSkOOT9IyWpzmsj7OH+1oOiCq9oa6PCxh//FWeTSb5Jjnpu8Lu8AsMnqZ3vMpfGliHoi/5l3CTS1ai7Pepvy1R7m0l1DQUoJk8+bcsg5ErmjLA2l2wNRtsAC/vqrtE8qtPq3UNtKSTcA+iQD7SIrvSxUJJ8ZKLSSQlTtjstC18+C2sMk45DQyw3iV1e93UJVX1UpJxog4KOgt4vfhRZkngs22f6AUbTn+3r7vtYOBaJJp3VytcSwT+srpsSAzwnDiz20qpfKqchXC3LoDWWGrSOOc8+KMFxWw2COIcFK4JBOfvZWftFBT6HjKgPIywjG4L9eVu03TSG8CFMAbb/mWeqN9yFUlBt5dcMhDA0L3bx69X/i90tE4h7ajH6IRFDlfWWRPt4X1TwbMzLW10fZhPt8mqK5a2rnIGtIJm3TAdt2Aokq6Iw1pvFNY9/6E2IG1B2sw3hyqi9jHM52hFZAncUBmF6TWO0tvpvr4XDt8pomvpxbIob2ypd5xjsLYNI3VA27nM6IsFqR+X5ncElkmKLDbqagX81vcxINho5FmljNt51aIKbxMjJZ3KYq2aR0KzEYqnaWiht0VYPwoqSZIXynurrSDOATDuh0CQH+Ggjjfw== cardno:24_736_654"
  ];

  networking = {
    hostName = "idkfa";
    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.wifi-key.path;
      networks."Temp Wifi".pskRaw = "ext:psk_home";
    };
  };

  services = {
    openssh.enable = true;
    tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale-key.path;
    };
  };

  time.timeZone = "America/Los_Angeles";

  system.stateVersion = "24.05";
}

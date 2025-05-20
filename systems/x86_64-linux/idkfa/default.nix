{ config, lib, pkgs, inputs, ... }:

{
  boot.initrd = {
    availableKernelModules = [ "ahci" "xhci_pci" "nvme" "usbhid" ];
    kernelModules = [ ];
  };
  boot.kernelModules = [ "kvm-amd" ];
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

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

  environment.etc = {
    "crypttab" = {
      mode = "0600";
      text = ''
        zdisk1_crypt UUID=b66648ce-953e-44db-9e77-997c86de51e3 /run/secrets/luks-zfs-keyfile
        zdisk2_crypt UUID=a7cd8b47-1650-4713-9050-2ffbee83e0b0 /run/secrets/luks-zfs-keyfile
        zdisk3_crypt UUID=f4f2c190-362f-4ed7-9d3a-95b844326445 /run/secrets/luks-zfs-keyfile
        zdisk4_crypt UUID=72cd4b4f-cf65-4112-aa50-781347a2379d /run/secrets/luks-zfs-keyfile
        zdisk5_crypt UUID=35811318-4c91-48fd-8b7f-73087198a98b /run/secrets/luks-zfs-keyfile
      '';
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
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      zdisk1 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:01:00.0-ata-1";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "zdisk1_crypt";
                initrdUnlock = false;
                settings = {
                  keyFile = config.sops.secrets.luks-zfs-keyfile.path;
                  allowDiscards = true;
                };
                passwordFile = config.sops.secrets.luks-zfs-passphrase.path;
                content = {
                  type = "zfs";
                  pool = "zdata";
                };
              };
            };
          };
        };
      };
      zdisk2 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:01:00.0-ata-2";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "zdisk2_crypt";
                initrdUnlock = false;
                settings = {
                  keyFile = config.sops.secrets.luks-zfs-keyfile.path;
                  allowDiscards = true;
                };
                passwordFile = config.sops.secrets.luks-zfs-passphrase.path;
                content = {
                  type = "zfs";
                  pool = "zdata";
                };
              };
            };
          };
        };
      };
      zdisk3 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:01:00.0-ata-3";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "zdisk3_crypt";
                initrdUnlock = false;
                settings = {
                  keyFile = config.sops.secrets.luks-zfs-keyfile.path;
                  allowDiscards = true;
                };
                passwordFile = config.sops.secrets.luks-zfs-passphrase.path;
                content = {
                  type = "zfs";
                  pool = "zdata";
                };
              };
            };
          };
        };
      };
      zdisk4 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:01:00.0-ata-4";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "zdisk4_crypt";
                initrdUnlock = false;
                settings = {
                  keyFile = config.sops.secrets.luks-zfs-keyfile.path;
                  allowDiscards = true;
                };
                passwordFile = config.sops.secrets.luks-zfs-passphrase.path;
                content = {
                  type = "zfs";
                  pool = "zdata";
                };
              };
            };
          };
        };
      };
      zdisk5 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:01:00.0-ata-5";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "zdisk5_crypt";
                initrdUnlock = false;
                settings = {
                  keyFile = config.sops.secrets.luks-zfs-keyfile.path;
                  allowDiscards = true;
                };
                passwordFile = config.sops.secrets.luks-zfs-passphrase.path;
                content = {
                  type = "zfs";
                  pool = "zdata";
                };
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        options.ashift = "12";
        rootFsOptions = {
          mountpoint = "none";
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          "com.sun:auto-snapshot" = "true";
        };
        datasets = {
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          "root/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "root/swap" = {
            type = "zfs_volume";
            size = "8G";
            content = { type = "swap"; };
            options = {
              volblocksize = "4096";
              compression = "zle";
              logbias = "throughput";
              sync = "always";
              primarycache = "metadata";
              secondarycache = "none";
              "com.sun:auto-snapshot" = "false";
            };
          };
        };
      };
      zdata = {
        type = "zpool";
        mode = "raidz2";
        options.ashift = "12";
        rootFsOptions = {
          mountpoint = "/zdata";
          compression = "lz4";
          acltype = "posixacl";
          xattr = "sa";
          "com.sun:auto-snapshot" = "true";
        };
      };
    };
  };
  snowfallorg.users.kitredgrave = {
    create = true;
    admin = true;
    home.enable = true;
  };
  users.users = {
    kitredgrave.openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFnTd9ZbGfMbH13K3bsBAJLZeTGxvnBbeLICaW5+hfmCAAAABHNzaDo= kitredgrave@Kits-MacBook-Air.local"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1u57T9mio+04M7qU0ERvd0Kz1jN7RCxleVe141HcGeoToWVwDZjxcIzmfLBKCaSkOOT9IyWpzmsj7OH+1oOiCq9oa6PCxh//FWeTSb5Jjnpu8Lu8AsMnqZ3vMpfGliHoi/5l3CTS1ai7Pepvy1R7m0l1DQUoJk8+bcsg5ErmjLA2l2wNRtsAC/vqrtE8qtPq3UNtKSTcA+iQD7SIrvSxUJJ8ZKLSSQlTtjstC18+C2sMk45DQyw3iV1e93UJVX1UpJxog4KOgt4vfhRZkngs22f6AUbTn+3r7vtYOBaJJp3VytcSwT+srpsSAzwnDiz20qpfKqchXC3LoDWWGrSOOc8+KMFxWw2COIcFK4JBOfvZWftFBT6HjKgPIywjG4L9eVu03TSG8CFMAbb/mWeqN9yFUlBt5dcMhDA0L3bx69X/i90tE4h7ajH6IRFDlfWWRPt4X1TwbMzLW10fZhPt8mqK5a2rnIGtIJm3TAdt2Aokq6Iw1pvFNY9/6E2IG1B2sw3hyqi9jHM52hFZAncUBmF6TWO0tvpvr4XDt8pomvpxbIob2ypd5xjsLYNI3VA27nM6IsFqR+X5ncElkmKLDbqagX81vcxINho5FmljNt51aIKbxMjJZ3KYq2aR0KzEYqnaWiht0VYPwoqSZIXynurrSDOATDuh0CQH+Ggjjfw== cardno:24_736_654"
    ];
    root.openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFnTd9ZbGfMbH13K3bsBAJLZeTGxvnBbeLICaW5+hfmCAAAABHNzaDo= kitredgrave@Kits-MacBook-Air.local"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1u57T9mio+04M7qU0ERvd0Kz1jN7RCxleVe141HcGeoToWVwDZjxcIzmfLBKCaSkOOT9IyWpzmsj7OH+1oOiCq9oa6PCxh//FWeTSb5Jjnpu8Lu8AsMnqZ3vMpfGliHoi/5l3CTS1ai7Pepvy1R7m0l1DQUoJk8+bcsg5ErmjLA2l2wNRtsAC/vqrtE8qtPq3UNtKSTcA+iQD7SIrvSxUJJ8ZKLSSQlTtjstC18+C2sMk45DQyw3iV1e93UJVX1UpJxog4KOgt4vfhRZkngs22f6AUbTn+3r7vtYOBaJJp3VytcSwT+srpsSAzwnDiz20qpfKqchXC3LoDWWGrSOOc8+KMFxWw2COIcFK4JBOfvZWftFBT6HjKgPIywjG4L9eVu03TSG8CFMAbb/mWeqN9yFUlBt5dcMhDA0L3bx69X/i90tE4h7ajH6IRFDlfWWRPt4X1TwbMzLW10fZhPt8mqK5a2rnIGtIJm3TAdt2Aokq6Iw1pvFNY9/6E2IG1B2sw3hyqi9jHM52hFZAncUBmF6TWO0tvpvr4XDt8pomvpxbIob2ypd5xjsLYNI3VA27nM6IsFqR+X5ncElkmKLDbqagX81vcxINho5FmljNt51aIKbxMjJZ3KYq2aR0KzEYqnaWiht0VYPwoqSZIXynurrSDOATDuh0CQH+Ggjjfw== cardno:24_736_654"
    ];
  };

  networking = {
    hostName = "idkfa";
    hostId = "ad6176a8";
    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.wifi-key.path;
      networks."Temp Wifi".pskRaw = "ext:psk_home";
    };
  };

  services = {
    openssh = {
      enable = true;
      hostKeys = [ ]; # do not generate new host keys
    };
    samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
      };
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
    tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale-key.path;
      authKeyParameters = {
        ephemeral = false;
        preauthorized = true;
      };
    };
  };

  time.timeZone = "America/Los_Angeles";

  system.stateVersion = "24.05";
}

{ config, lib, pkgs, ... }:

{
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
        datasets = {
          "backup" = {
            type = "zfs_fs";
            options.mountpoint = "/zdata/backup";
          };
          "hydrus-files" = {
            type = "zfs_fs";
            options.mountpoint = "/zdata/hydrus-files";
          };
          "media" = {
            type = "zfs_fs";
            options.mountpoint = "/zdata/media";
          };
          "steam-library" = {
            type = "zfs_fs";
            options.mountpoint = "/zdata/steam-library";
          };
          "unsorted" = {
            type = "zfs_fs";
            options.mountpoint = "/zdata/unsorted";
          };
        };
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
  services = {
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "idkfa";
          "netbios name" = "idkfa";
          "security" = "user";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        backup = {
          path = "/zdata/backup";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "writable" = "yes";
        };
        media = {
          path = "/zdata/media";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "writable" = "yes";
        };
        unsorted = {
          path = "/zdata/unsorted";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "writable" = "yes";
        };
      };
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}

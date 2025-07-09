{
  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters =
      [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    allowUnfree = true;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian-nixos = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "";
    };
  };

  outputs = { self, ... }@inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      snowfall.namespace = "local";

      homes.modules = with inputs; [
        sops-nix.homeManagerModules.sops
        nix-doom-emacs-unstraightened.homeModule
        quadlet-nix.homeManagerModules.quadlet
      ];

      systems.modules.nixos = with inputs; [
        disko.nixosModules.disko
        nixos-generators.nixosModules.all-formats
        sops-nix.nixosModules.sops
        quadlet-nix.nixosModules.quadlet
        { home-manager.backupFileExtension = "hmbackup"; }
      ];

      systems.modules.darwin = with inputs; [
        sops-nix.darwinModules.sops
        nix-rosetta-builder.darwinModules.default
        { home-manager.backupFileExtension = "hmbackup"; }
      ];

      systems.hosts.raspberrypi.modules = with inputs; [
        nixos-hardware.nixosModules.raspberry-pi-4
        nixos-generators.nixosModules.sd-aarch64
      ];

      systems.hosts.kitdeck.modules = with inputs;
        [ jovian-nixos.nixosModules.jovian ];

      alias = {
        checks.default = "default";
        shells.default = "default";
      };
    } // {
      deploy.nodes = {
        idkfa = {
          hostname = "idkfa.risk-puffin.ts.net";
          user = "kitredgrave";
          interactiveSudo = true;
          remoteBuild = true;
          profiles = {
            system = {
              path = with inputs;
                deploy-rs.lib.x86_64-linux.activate.nixos
                self.nixosConfigurations.idkfa;
            };
          };
        };
        xyzzy = {
          hostname = "xyzzy.kitredgrave.net";
          user = "kitredgrave";
          interactiveSudo = true;
          remoteBuild = true;
          profiles = {
            system = {
              path = with inputs;
                deploy-rs.lib.x86_64-linux.activate.nixos
                self.nixosConfiguration.xyzzy;
            };
          };
        };
      };
    };
}

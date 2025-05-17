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
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      snowfall.namespace = "local";

      homes.modules = with inputs; [ sops-nix.homeManagerModules.sops ];

      systems.modules.nixos = with inputs; [
        disko.nixosModules.disko
        nixos-generators.nixosModules.all-formats
        sops-nix.nixosModules.sops
      ];

      systems.modules.darwin = with inputs; [
        sops-nix.darwinModules.sops
        nix-rosetta-builder.darwinModules.default
      ];

      systems.hosts.raspberrypi.modules = with inputs; [
        nixos-hardware.nixosModules.raspberry-pi-4
        nixos-generators.nixosModules.sd-aarch64
      ];

      systems.hosts.steamdeck.modules = with inputs;
        [ jovian-nixos.nixosModules.jovian ];

      alias.shells.default = "default";
    };
}

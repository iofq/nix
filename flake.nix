{
  description = "Home Manager && NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim = {
      url = "github:iofq/nvim.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, nixos-hardware, nvim, ... } @inputs:
  let
    username = "e";
  in {
    nixosConfigurations = ( import ./nixos { inherit inputs; } );
    homeConfigurations = (
      import ./home { inherit inputs; }
      );
    };
  }

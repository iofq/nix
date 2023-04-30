{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 
    sops-nix.url = "github:Mic92/sops-nix";
  }; 
  outputs = { self, nixpkgs, home-manager, nixos-hardware, sops-nix, ... }:
  let
    username = "e";
  in {
    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit nixpkgs home-manager nixos-hardware sops-nix username;
      }
      );
    };
  }

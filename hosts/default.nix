{ lib, nixpkgs, username, home-manager, nixos-hardware, sops-nix, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
  {
    t14 = lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit username;
        host = {
          hostName = "t14";
        };
      };
      modules = [
        sops-nix.nixosModules.sops
        ./configuration.nix
        ./t14/configuration.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit username;
          };
          home-manager.sharedModules = [
            sops-nix.homeManagerModule
          ];
          home-manager.users.${username} = {
            programs.home-manager.enable = true;
            imports = [
              ./t14/home.nix
            ];
          };
        }
      ];
    };

  }


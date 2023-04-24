{ lib, nixpkgs, username, home-manager, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
  {
    t14 = lib.nixosSystem {                                # Laptop profile
    inherit system;
    specialArgs = {
      inherit username;
      host = {
        hostName = "t14";
      };
    };
    modules = [
      ./configuration.nix
      ./t14/configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit username;
          host = {
            hostName = "t14";
          };
        };
        home-manager.users.${username} = {
          imports = [
            ./home.nix
            ./t14/home.nix
          ];
        };
      }
    ];
  };

}


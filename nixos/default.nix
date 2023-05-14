{ inputs, ... }:
let
in
  { t14 = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        system = "x86_64-linux";
        host = {
          hostName = "t14";
          username = "e";
        };
      };
      modules = [
        ./configuration.nix
        ./t14/configuration.nix
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
      ];
    };

  }


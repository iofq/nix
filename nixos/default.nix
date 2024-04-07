{
  inputs,
  pkgs,
  attrs,
  system,
  ...
}: let
  defaultModules = [
    inputs.sops-nix.nixosModules.sops
    inputs.nix-index-database.nixosModules.nix-index
  ];
in {
  t14 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs system pkgs attrs;
      host = {
        hostName = "t14";
        inherit (attrs) username;
      };
    };
    modules =
      defaultModules
      ++ [
        ./configuration.nix
        ./t14/configuration.nix
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
      ];
  };
  rknrd = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs system pkgs;
      host = {
        hostName = "rknrd";
        inherit (attrs) username;
      };
    };
    modules =
      defaultModules
      ++ [
        ./configuration.nix
        ./racknerd/configuration.nix
      ];
  };
  htz = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs system pkgs;
      addressList = {
        vm-k3s = {
          name = "vm-k3s";
          ipv4 = "10.0.0.3";
          subnet = "/24";
          mac = "02:00:00:00:00:03";
        };
      };
      host = {
        hostName = "htz";
        inherit (attrs) username;
      };
    };
    modules =
      defaultModules
      ++ [
        ./configuration.nix
        ./htz/configuration.nix
        inputs.ethereum-nix.nixosModules.default
        inputs.microvm.nixosModules.host
      ];
  };
}

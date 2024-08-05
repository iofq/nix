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
}

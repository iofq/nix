{
  inputs,
  pkgs,
  attrs,
  system,
  ...
}: {
  t14 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs system pkgs attrs;
      host = {
        hostName = "t14";
        inherit (attrs) username;
      };
    };
    modules = [
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
    modules = [
      ./configuration.nix
      ./racknerd/configuration.nix
    ];
  };
  htz = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs system pkgs;
      addressList = {
        vm-headscale = {
          ipv4 = "10.0.0.2";
          subnet = "/24";
          mac = "02:00:00:00:00:02";
        };
      };
      host = {
        hostName = "htz";
        inherit (attrs) username;
      };
    };
    modules = [
      ./configuration.nix
      ./htz/configuration.nix
      inputs.ethereum-nix.nixosModules.default
      inputs.microvm.nixosModules.host
    ];
  };
}

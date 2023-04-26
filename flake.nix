{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }:
    let
      username = "e";
    in {
	nixosConfigurations = (
		import ./hosts {
			inherit (nixpkgs) lib;
            inherit nixos-hardware;
			inherit nixpkgs home-manager username;
		}
	);
    };
}

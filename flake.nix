{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      username = "e";
    in {
	nixosConfigurations = (
		import ./hosts {
			inherit (nixpkgs) lib;
			inherit nixpkgs home-manager username;
		}
	
	);
    };
}

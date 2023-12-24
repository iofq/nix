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
    tfa = {
      url = "github:iofq/2fa";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, nixos-hardware, nvim, ... } @inputs:
  let
    attrs = {
      username = "e";
    };
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (final: prev: {
          inherit (inputs.nvim.packages.${final.system}) full;
          inherit (inputs.tfa.packages.${final.system}) twofa;
        })
      ];
    };
  in {
    nixosConfigurations = (
      import ./nixos { inherit inputs pkgs attrs; }
    );
    homeConfigurations = (
      import ./home-manager { inherit inputs pkgs attrs; }
    );
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.nix
        pkgs.home-manager
        pkgs.git
      ];
    };
  };
}

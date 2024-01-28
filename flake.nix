{
  description = "Home Manager && NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    deploy-rs.url = "github:serokell/deploy-rs";
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
    ethereum-nix = {
      url = "git+file:///home/e/dev/ethereum.nix/";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.foundry-nix.url = "github:shazow/foundry.nix";
    };
    microvm = {
        url = "github:astro/microvm.nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, nixos-hardware, nvim, ethereum-nix, deploy-rs, ... } @inputs:
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
      import ./nixos { inherit inputs pkgs attrs system ethereum-nix; }
    );
    homeConfigurations = (
      import ./home-manager { inherit inputs pkgs attrs; }
      );
    deploy.nodes = {
      htz = {
        hostname = "htz";
        sshUser = "root";
        remoteBuild = true;
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.htz;
        };
      };
      racknerd = {
        hostname = "racknerd";
        sshUser = "e";
        remoteBuild = true;
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.rknrd;
        };
      };
    };
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.nix
        pkgs.home-manager
        pkgs.git
        deploy-rs.packages.${system}.deploy-rs
      ];
    };
  };
}

{
  description = "Home Manager && NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nvim,
    ethereum-nix,
    deploy-rs,
    systems,
    ...
  } @ inputs: let
    attrs = {
      username = "e";
    };
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (final: _prev: {
          inherit (inputs.nvim.packages.${final.system}) full;
          inherit (inputs.tfa.packages.${final.system}) twofa;
        })
      ];
    };
    eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    treefmtEval = eachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    nixosConfigurations = import ./nixos {inherit inputs pkgs attrs system ethereum-nix;};
    homeConfigurations = import ./home-manager {inherit inputs pkgs attrs;};
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
    checks = {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks.treefmt.enable = true;
        hooks.treefmt.package = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
      };
    };
    formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
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

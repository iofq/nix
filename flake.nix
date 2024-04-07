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
      #url = "github:nix-community/ethereum.nix";
      url = "git+file:///home/e/dev/ethereum.nix/";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
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
        (final: _prev:
          {
            inherit (inputs.nvim.packages.${final.system}) full;
            inherit (inputs.tfa.packages.${final.system}) twofa;
          }
          // import ./overlay.nix {inherit pkgs;})
      ];
    };
    eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    treefmtEval = eachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    nixosConfigurations = import ./nixos {inherit inputs pkgs attrs system;};
    homeConfigurations = import ./home-manager {inherit inputs pkgs attrs;};
    deploy.nodes = {
      htz = {
        hostname = "htz";
        sshUser = "e";
        remoteBuild = true;
        profiles.system = {
          user = "root";
          path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.htz;
        };
      };
      racknerd = {
        hostname = "racknerd";
        sshUser = "e";
        remoteBuild = true;
        profiles.system = {
          user = "root";
          path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.rknrd;
        };
      };
    };
    checks = {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          treefmt.enable = true;
        };
        settings.treefmt.package = treefmtEval.${system}.config.build.wrapper;
      };
    };
    formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
    devShells.${system}.default = pkgs.mkShell {
      inherit (self.checks.pre-commit-check) shellHook;
      buildInputs = [
        pkgs.nix
        pkgs.home-manager
        pkgs.git
        pkgs.ssh-to-age
        pkgs.sops
        pkgs.age
        inputs.deploy-rs.packages.${system}.deploy-rs
        treefmtEval.${system}.config.build.wrapper
      ];
    };
  };
}

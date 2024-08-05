{
  description = "Home Manager && NixOS configuration";
  inputs = {
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    sops-nix.url = "github:Mic92/sops-nix";
    tfa.url = "github:iofq/2fa";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nvim = {
      url = "github:iofq/nvim.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
        (final: _prev: {
          steam = pkgs.writeShellScriptBin "steam" ''
            flatpak run com.valvesoftware.Steam -pipewire "$@"
          '';
          inherit (inputs.nvim.packages.${final.system}) full;
          inherit (inputs.tfa.packages.${final.system}) twofa;
        })
      ];
    };
    eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    treefmtEval = eachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    nixosConfigurations = import ./nixos {inherit inputs pkgs attrs system;};
    homeConfigurations = import ./home-manager {inherit inputs pkgs attrs;};
    checks = {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          treefmt.enable = true;
          treefmt.package = treefmtEval.${system}.config.build.wrapper;
        };
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
        treefmtEval.${system}.config.build.wrapper
      ];
    };
  };
}

{ inputs, ...}:
{
  "e" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [
        (final: prev: {
          inherit (inputs.nvim.packages.${final.system}) iofqvim;
        })
      ];
    };
    extraSpecialArgs = { 
      inherit inputs;
      host = {
        hostName = "t14";
        username = "e";
      };
    };
    modules = [
      ./t14/home.nix
    ];
  };
}


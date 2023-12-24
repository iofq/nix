{ inputs, pkgs, attrs, ...}:
{
  "e" = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs attrs;
      host = {
        hostName = "t14";
        username = attrs.username;
      };
    };
    modules = [
      ./t14/home.nix
      ./home.nix
    ];
  };
  "minimal" = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs attrs;
      host = {
        hostName = "e";
        username = attrs.username;
      };
    };
    modules = [
      ./home.nix
    ];
  };
}


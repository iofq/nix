{
  inputs,
  pkgs,
  attrs,
  ...
}: {
  inputs.home-manager.useGlobalPkgs = true;
  "e" = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs attrs;
      host = {
        hostName = "t14";
        inherit (attrs) username;
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
      targets.genericLinux.enable = true;
      host = {
        hostName = "e";
        inherit (attrs) username;
      };
    };
    modules = [
      ./home.nix
      ./min.nix
    ];
  };
}

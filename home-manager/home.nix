{
  inputs,
  attrs,
  ...
}: {
  programs.home-manager.enable = true;
  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
  home = {
    inherit (attrs) username;
    stateVersion = "22.11";
    homeDirectory = "/home/" + attrs.username;
    file = {
      ".local/bin" = {
        source = ../bin;
      };
    };
  };
  imports = [./shared/programs/min.nix];
  xdg.enable = true;
}

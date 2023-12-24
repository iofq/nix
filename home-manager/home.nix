{ inputs, pkgs, ... }:
{
  programs.home-manager.enable = true;
  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
  home = {
    stateVersion = "22.11";
  };
  imports = [ ./shared/programs/min.nix ];
  xdg.enable = true;
}

{ home-manager, config, lib, pkgs, ... }:
{
  imports = [
    ./librewolf
    ./alacritty
    (import ./sway)
    ./xdg
    ./audio
  ];
}

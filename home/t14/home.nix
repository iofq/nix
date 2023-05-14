{ pkgs, ... }:
{
  imports = [
    ../../modules/wayland
    ../../modules/librewolf
    ../common.nix
  ];
  home = {
    username = "e";
    homeDirectory = "/home/e";
    packages = with pkgs; [
      discord
      signal-desktop
      runelite
      framesh
			iofqvim
    ];
  };
}

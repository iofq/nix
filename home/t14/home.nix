{ pkgs, ... }:
{
  imports = [
    ../../modules/wayland
    ../../modules/librewolf
  ];
  home = {
    username = "e";
    homeDirectory = "/home/e";
    packages = with pkgs; [
      discord
      signal-desktop
      runelite
      framesh
      ledger-live-desktop
      prismlauncher
      chromium
      oath-toolkit
    ];
  };
}

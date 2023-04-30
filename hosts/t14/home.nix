{ username, pkgs, ... }:
{
  imports = [
    ../../modules/wayland
    ../../modules/librewolf
    ../home.nix
  ];
  home = {
    packages = with pkgs; [
      pulseaudio
      pulsemixer
      alsa-utils
      discord
      signal-desktop
      runelite
      framesh
    ];
  };
}

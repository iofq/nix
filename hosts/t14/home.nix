{ username, pkgs, ... }:
{
  imports = [
    ../../modules/wayland
    ../../modules/librewolf
  ];
  home = {
    packages = with pkgs; [
      neofetch
      pulseaudio
      pulsemixer
      alsa-utils
      discord
      signal-desktop
      runelite
    ];
  };
}

{ username, pkgs, ... }:
{
  imports = [
    ../../modules/wayland
    ../../modules/librewolf
  ];
  home = {
    packages = with pkgs; [
      neofetch
      discord
      signal-desktop
      pulseaudio
    ];
  };
}

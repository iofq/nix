{ pkgs, attrs, ... }:
{
  imports = [
    ../shared/programs/default.nix
    ../shared/wayland/default.nix
  ];
  home = {
    username = attrs.username;
    homeDirectory = "/home/" + attrs.username;
    packages = with pkgs; [
      # gaming
      prismlauncher
      runelite
      jdk17

      # comms
      signal-desktop
      discord

      # apps
      framesh
      chromium

      # font
      spleen

      # sysutils
      appimage-run
      wireguard-tools

    ];
  };
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "10110110.xyz" = {
        hostname = "10110110.xyz";
        identityFile = "/home/e/.ssh/racknerd";
      };
    };
  };
  fonts.fontconfig.enable = true;
  systemd.user.startServices = "sd-switch";
}

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
      "racknerd.10110110.xyz" = {
        hostname = "contabo.10110110.xyz";
        identityFile = "/home/e/.ssh/racknerd";
      };
      "contabo.10110110.xyz" = {
        hostname = "contabo.10110110.xyz";
        identityFile = "/home/e/.ssh/id_ed25519";
      };
      "consensus" = {
        hostname = "consensus";
        identityFile = "/home/e/.ssh/id_ed25519";
      };
    };
  };
  fonts.fontconfig.enable = true;
  systemd.user.startServices = "sd-switch";
}

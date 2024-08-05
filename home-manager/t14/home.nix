{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../shared/programs/default.nix
    ../shared/wayland/default.nix
  ];
  home = {
    packages = with pkgs; [
      # gaming
      steam
      prismlauncher
      runelite
      jdk21

      # comms
      signal-desktop
      discord

      # apps
      (chromium.override {commandLineArgs = "--load-media-router-component-extension=1";})
      pcmanfm
      feh
      ffmpeg
      mpv
      vlc
      wdisplays
      piper
      calibre

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
      "racknerd" = {
        hostname = "racknerd.10110110.xyz";
        identityFile = "/home/e/.ssh/racknerd";
      };
      "htz" = {
        hostname = "htz.10110110.xyz";
        identityFile = "/home/e/.ssh/id_ed25519";
      };
      "ocx" = {
        hostname = "ocx.10110110.xyz";
        identityFile = "/home/e/.ssh/oracle";
      };
    };
  };
  fonts.fontconfig.enable = lib.mkForce true;
  systemd.user.startServices = "sd-switch";
}

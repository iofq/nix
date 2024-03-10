{
  pkgs,
  lib,
  attrs,
  ...
}: {
  imports = [
    ../shared/programs/default.nix
    ../shared/wayland/default.nix
  ];
  home = {
    inherit (attrs) username;
    homeDirectory = "/home/" + attrs.username;
    packages = with pkgs; [
      # gaming
      steam
      prismlauncher
      runelite
      jdk17

      # comms
      signal-desktop
      # discord # using Webcord via flatpak

      # apps
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
      "racknerd" = {
        hostname = "racknerd.10110110.xyz";
        identityFile = "/home/e/.ssh/racknerd";
      };
      "htz" = {
        hostname = "htz.10110110.xyz";
        identityFile = "/home/e/.ssh/id_ed25519";
      };
    };
  };
  fonts.fontconfig.enable = lib.mkForce true;
  systemd.user.startServices = "sd-switch";
}

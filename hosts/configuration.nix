{ config, pkgs, username, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
  time.timeZone = "America/Chicago";
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "plugdev"
      "video"
    ];
  };
  users.groups.plugdev = {};
  security.pam.services.swaylock = {};
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "22.11";
}

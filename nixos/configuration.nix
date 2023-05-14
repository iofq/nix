{ packages, host, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  users.groups.plugdev = {}; # Create plugdev group

  users.users.${host.username} = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "plugdev"
      "video"
    ];
  };
  security.pam.services.swaylock = {};
  time.timeZone = "America/Chicago";

  # Enable flakes and unfree packages
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "00:00";
    options = "--delete-older-than 14d";
  };
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "22.11";
}

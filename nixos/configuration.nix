{ packages, host, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  users.groups.plugdev = {}; # Create plugdev group

  networking.hostName = host.hostName;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [11111];
    allowedUDPPorts = [];
    logRefusedConnections = true;
  };
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
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };
  nix.gc = {
    automatic = true;
    dates = "00:00";
    options = "--delete-older-than 14d";
  };

  system.stateVersion = "22.11";
}

{ packages, host, system, ... }:
{
  users.groups.plugdev = {}; # Create plugdev group
  networking.hostName = host.hostName;
  users.users.${host.username} = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "plugdev"
      "video"
    ];
  };
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
}

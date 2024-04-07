{
  pkgs,
  host,
  ...
}: {
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
  environment.systemPackages = with pkgs; [vim];
  programs.nix-index.enableBashIntegration = false;
  programs.nix-index.enableZshIntegration = false;
  programs.nix-index-database.comma.enable = true;
  time.timeZone = "America/Chicago";

  # Enable flakes and unfree packages
  nix.settings = {
    auto-optimise-store = true;
    substituters = ["https://nix-community.cachix.org"];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = [host.username];
    experimental-features = ["nix-command" "flakes"];
  };
  nix.gc = {
    automatic = true;
    dates = "00:00";
    options = "--delete-older-than 14d";
  };
}

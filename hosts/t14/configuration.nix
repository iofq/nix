{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nano.nix
  ];
  networking.hostName = "t14"; # Define your hostname.
  environment.systemPackages = with pkgs; [
    cryptsetup
  ];
  fonts = {
    fonts = with pkgs; [
      spleen
    ];
  };
  programs.light.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "22.11"; # Did you read the comment?
}

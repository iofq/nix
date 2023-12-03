{ pkgs, nixos-hardware, host, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./nano.nix
    ];
    environment.systemPackages = with pkgs; [
      cryptsetup
      nfs-utils
    ];
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    programs.light.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    programs.ssh = {
      startAgent = true;
    };
    services.flatpak.enable = true;
    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
      };
    };
    hardware.opengl.enable = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    system.stateVersion = "22.11"; 
  }

{ pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./nano.nix
    ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.networkmanager.enable = true;
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [11111];
      allowedUDPPorts = [];
      logRefusedConnections = true;
    };
    environment.systemPackages = with pkgs; [
      cryptsetup
      nfs-utils
    ];
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    programs.light.enable = true;
    security.pam.services.swaylock = {};
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    programs.ssh = {
      startAgent = true;
    };
    services.flatpak.enable = true;
    services.dbus.enable = true;
    xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        wlr.enable = true;
        extraPortals = [
            pkgs.xdg-desktop-portal-gtk
            pkgs.xdg-desktop-portal-wlr
        ];
        config = {
          common = {
            default = [
              "*"
            ];
          };
        };
    };
    hardware.opengl.enable = true;
    hardware.opengl.extraPackages = [ 
      pkgs.mesa.drivers
      pkgs.libGL
    ];
    hardware.opengl.setLdLibraryPath = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    system.stateVersion = "22.11"; 
  }

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
    services.dbus.enable = true;
    xdg = {
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        wlr.enable = true;
        config = {
          common = {
            default = [
              "wlr"
            ];
          };
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

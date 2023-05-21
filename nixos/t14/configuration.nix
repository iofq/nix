{ pkgs, nixos-hardware, host, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./nano.nix
    ];
    networking.hostName = host.hostName;
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    }
    environment.systemPackages = with pkgs; [
      cryptsetup
    ];

    programs.light.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    hardware.opengl.enable = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    system.stateVersion = "22.11"; 
  }

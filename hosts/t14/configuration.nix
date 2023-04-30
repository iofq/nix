{ config, pkgs, nixos-hardware, sops-nix, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./nano.nix
    ];
    networking.hostName = "t14"; 
    environment.systemPackages = with pkgs; [
      cryptsetup
    ];
    fonts = {
      fonts = with pkgs; [
        spleen
        roboto
      ];
    };
    programs.light.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    nixpkgs.config.allowUnfree = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    hardware.opengl.enable = true;
    system.stateVersion = "22.11"; 
  }

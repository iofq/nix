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
      allowedTCPPorts = [11111 80];
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

    services.tlp = {
        enable = true;
        settings = {
            WIFI_PWR_ON_BAT = "off";
            CPU_BOOST_ON_BAT = "0";
            CPU_BOOST_ON_AC = "1";

            PLATFORM_PROFILE_ON_AC = "performance";
            PLATFORM_PROFILE_ON_BAT = "low-power";
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

            CPU_MIN_PERF_ON_AC = 0;
            CPU_MAX_PERF_ON_AC = 100;
            CPU_MIN_PERF_ON_BAT = 0;
            CPU_MAX_PERF_ON_BAT = 25;
            RADEON_DPM_STATE_ON_AC="performance";
            RADEON_DPM_STATE_ON_BAT="battery";
            RADEON_POWER_PROFILE_ON_AC="high";
            RADEON_POWER_PROFILE_ON_BAT="low";

           #Optional helps save long term battery health
           START_CHARGE_THRESH_BAT0 = 80; # bellow it starts to charge
           STOP_CHARGE_THRESH_BAT0 = 95; # above it stops charging
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

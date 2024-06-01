{
  pkgs,
  attrs,
  ...
}: let
  # Horrid workaround for https://github.com/nix-community/home-manager/issues/1011
  homeManagerSessionVars = "/etc/profiles/per-user/${attrs.username}/etc/profile.d/hm-session-vars.sh";
in {
  imports = [
    ./hardware-configuration.nix
    ./nano.nix
    ./backups.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    cryptsetup
    nfs-utils
  ];
  environment.extraInit = "[[ -f ${homeManagerSessionVars} ]] && source ${homeManagerSessionVars} && echo 'x' > /tmp/test";

  # Networking
  networking = {
    nameservers = ["1.1.1.1#one.one.one.one"];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [11111];
      allowedUDPPorts = [];
      trustedInterfaces = ["tailscale0"];
      logRefusedConnections = true;
    };
  };
  services.resolved = {
    enable = true;
    fallbackDns = [
      "1.1.1.1#one.one.one.one"
    ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };
  services.tailscale.enable = true;

  # Services
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
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
  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  services.tlp = {
    enable = true;
    settings = {
      WIFI_PWR_ON_BAT = "off";
      START_CHARGE_THRESH_BAT0 = 80;
      STOP_CHARGE_THRESH_BAT0 = 85;
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "battery";
      RADEON_POWER_PROFILE_ON_AC = "high";
      RADEON_POWER_PROFILE_ON_BAT = "low";
    };
  };

  services.ratbagd.enable = true; # Logitech
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            pause = "timeout(esc, 150, space)";
            scrolllock = "layer(shift)";
          };
        };
      };
    };
  };

  hardware.opengl = {
    enable = true;
    setLdLibraryPath = true;
    extraPackages = [
      pkgs.mesa.drivers
      pkgs.libGL
    ];
  };
  # Set a sane system-wide default font
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["UbuntuMono"];})
    spleen
  ];
  fonts.fontconfig.defaultFonts.monospace = ["UbuntuMono"];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  system.stateVersion = "22.11";
}

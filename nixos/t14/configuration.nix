{
  config,
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

  environment.systemPackages = with pkgs; [
    cryptsetup
    nfs-utils
  ];
  environment.extraInit = "[[ -f ${homeManagerSessionVars} ]] && source ${homeManagerSessionVars} && echo 'x' > /tmp/test";

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = ["zfs"];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    zfs.forceImportRoot = false;
  };
  # Networking
  networking = {
    hostId = "1185c58e";
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

  # Services
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  security.pam.services.swaylock = {};
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  programs = {
    light.enable = true;
    hyprland.enable = true;
    ssh = {
      startAgent = true;
    };
  };
  services = {
    resolved = {
      enable = true;
      fallbackDns = [
        "1.1.1.1#one.one.one.one"
      ];
      extraConfig = ''
        DNSOverTLS=yes
      '';
    };
    tailscale.enable = true;
    avahi.enable = true; # chromecast
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    flatpak.enable = true;
    dbus.enable = true;

    tlp = {
      enable = true;
      settings = {
        WIFI_PWR_ON_BAT = "off";
        START_CHARGE_THRESH_BAT0 = 80;
        STOP_CHARGE_THRESH_BAT0 = 85;
      };
    };
    ratbagd.enable = true; # Logitech
    keyd = {
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
  system.stateVersion = "22.11";
}

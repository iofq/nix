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
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    cryptsetup
    nfs-utils
    comma
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
    libvirtd.enable = true;
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
      CPU_BOOST_ON_BAT = "0";
      CPU_BOOST_ON_AC = "1";

      PLATFORM_PROFILE_ON_AC = "low-power";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 25;
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "battery";
      RADEON_POWER_PROFILE_ON_AC = "high";
      RADEON_POWER_PROFILE_ON_BAT = "low";

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 80; # bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 95; # above it stops charging
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

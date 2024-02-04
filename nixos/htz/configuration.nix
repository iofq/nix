{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./vms
    ./eth.nix
  ];
  environment.systemPackages = with pkgs; [
    vim
    git
    bridge-utils
    comma
  ];
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  networking = {
    hostName = "htz";
    domain = "";
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443];
      allowedUDPPorts = [];
      logRefusedConnections = true;
    };
  };
  fileSystems."/var/lib/private/nimbus-beacon-mainnet" = {
    device = "/eth2";
    options = ["bind"];
  };
  fileSystems."/var/lib/private/geth-mainnet" = {
    device = "/eth1";
    options = ["bind"];
  };
  services = let
    domain = "ts.10110110.xyz";
  in {
    openssh.enable = true;
    tailscale.enable = true;
    headscale = {
      enable = true;
      address = "0.0.0.0";
      port = 8080;
      serverUrl = "https://${domain}";
      dns = {baseDomain = domain;};
      settings = {logtail.enabled = false;};
    };

    nginx = {
      enable = true;
      virtualHosts.${domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8080";
          proxyWebsockets = true;
        };
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "mail@10110110.xyz";
  };
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHM4Zr0PFN7QdOG2aJ+nuzRCK6caulrpY6bphA1Ppl8Y e@t14''];
    };
    e = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      home = "/home/e";
      openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHM4Zr0PFN7QdOG2aJ+nuzRCK6caulrpY6bphA1Ppl8Y e@t14''];
    };
  };
  security.sudo.wheelNeedsPassword = false;
  nix.settings.trusted-users = ["e"];
  system.stateVersion = "23.11";
}

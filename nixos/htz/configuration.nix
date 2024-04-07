{
  addressList,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./vms
    ./eth.nix
  ];
  environment.systemPackages = with pkgs; [
    git
    bridge-utils
  ];
  networking = {
    hostName = "htz";
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
      logRefusedConnections = true;
      trustedInterfaces = ["microvm"];
    };
    # Map addressList to entries in /etc/hosts
    extraHosts =
      builtins.concatStringsSep "\n"
      (lib.attrsets.mapAttrsToList (k: v: "${v.ipv4} ${k}") addressList);
  };
  fileSystems."/var/lib/private/nimbus-beacon-mainnet" = {
    device = "/eth2";
    options = ["bind"];
  };
  fileSystems."/var/lib/private/geth-mainnet" = {
    device = "/eth1";
    options = ["bind"];
  };
  services = {
    tailscale.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
    };
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

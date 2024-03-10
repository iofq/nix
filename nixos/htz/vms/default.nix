{
  inputs,
  lib,
  pkgs,
  system,
  addressList,
  ...
}: let
  genVMConfig = {
    name,
    config ? {},
    ...
  }: {
    restartIfChanged = true;
    inherit pkgs;
    # Merge custom config passed with defaults
    config =
      lib.attrsets.recursiveUpdate
      {
        microvm = {
          shares = [
            {
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
              proto = "virtiofs";
            }
          ];
          interfaces = [
            {
              type = "tap";
              id = name;
              inherit (addressList.${name}) mac;
            }
          ];
        };
        systemd.network = {
          enable = true;
          networks."20-lan" = {
            matchConfig.Type = "ether";
            networkConfig = {
              Address = [(addressList.${name}.ipv4 + addressList.${name}.subnet)];
              Gateway = "10.0.0.1";
              DNS = ["1.1.1.1"];
              IPv6AcceptRA = true;
              DHCP = "no";
            };
          };
          networks."19-docker" = {
            matchConfig.Name = "veth*";
            linkConfig = {
              Unmanaged = true;
            };
          };
        };
        services.openssh = {
          enable = true;
          listenAddresses = [
            {
              addr = addressList.${name}.ipv4;
              port = 22;
            }
          ];
          settings.PasswordAuthentication = false;
          settings.KbdInteractiveAuthentication = false;
        };
        networking.firewall = {
          enable = true;
          allowedTCPPorts = [22];
          allowedUDPPorts = [];
          logRefusedConnections = true;
        };
        users.users = {
          root = {
            openssh.authorizedKeys.keys = [
              ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIItTJm2iu/5xacOoh4/JAvMtHE62duDlVVXpvVP+uQMR root@htz''
              ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHM4Zr0PFN7QdOG2aJ+nuzRCK6caulrpY6bphA1Ppl8Y e@t14''
            ];
          };
          e = {
            isNormalUser = true;
            extraGroups = ["wheel"];
            openssh.authorizedKeys.keys = [
              ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIItTJm2iu/5xacOoh4/JAvMtHE62duDlVVXpvVP+uQMR root@htz''
              ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU2TUxKyGKoZ68IG4hw23RmxVf72u5K9W0StkgTr0b2 e@t14''
            ];
          };
        };
        documentation.enable = false;
        system.stateVersion = "23.11";
      }
      config;
  };
in {
  microvm.vms = {
    vm-pool = genVMConfig {
      name = "vm-pool";
      config = import ./pool.nix {inherit pkgs system inputs;};
    };
    vm-k3s = genVMConfig {
      name = "vm-k3s";
      config = import ./k3s.nix {inherit pkgs;};
    };
  };
}

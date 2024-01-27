{ modulesPath, lib, ... }:
{
  system.stateVersion = "23.11"; 
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  boot = {
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    initrd.availableKernelModules = [
      "ata_piix"
        "uhci_hcd"
        "xen_blkfront"
        "vmw_pvscsi"
    ];
    initrd.kernelModules = [ "nvme" ];
  };
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/5679-B4CD";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/mapper/ssd1-root";
      fsType = "ext4";
    };
  };
  swapDevices = [{
    device = "/dev/dm-1";
  }];
  networking.useNetworkd = true;
  networking.nat = {
    enable = true;
    externalInterface = "enp0s31f6";
    internalInterfaces = [ "microvm" ];
  };
  systemd.network = {
    enable = true;
    netdevs = {
      "10-microvm".netdevConfig = {
        Kind = "bridge";
        Name = "microvm";
      };
    };
    networks = {
      "10-microvm" = {
        matchConfig.Name = "microvm";
        networkConfig = {
          DHCPServer = true;
        };
        addresses = [ {
          addressConfig.Address = "10.0.0.1/24";
        }];
      };
      "11-microvm" = {
        matchConfig.Name = "vm-*";
        networkConfig.Bridge = "microvm";
      };
    };
  };
}

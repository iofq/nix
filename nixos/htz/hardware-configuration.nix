{
  modulesPath,
  lib,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  boot = {
    tmp.cleanOnBoot = true;
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
    initrd.kernelModules = ["nvme"];
  };
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/8480-5FBB";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/mapper/ssd1-root";
      fsType = "ext4";
    };
  };
  swapDevices = [
    {
      device = "/dev/dm-1";
    }
  ];
  zramSwap.enable = false;
  networking = {
    useNetworkd = true;
    nat = {
      enable = true;
      externalInterface = "enp0s31f6";
      internalInterfaces = ["microvm"];
    };
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
          IPv6SendRA = true;
        };
        addresses = [
          {
            addressConfig.Address = "10.0.0.1/24";
          }
        ];
      };
      "11-microvm" = {
        matchConfig.Name = "vm-*";
        networkConfig.Bridge = "microvm";
      };
    };
  };
}

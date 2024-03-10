{
  modulesPath,
  lib,
  config,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];
  boot = {
    kernelModules = ["kvm-intel"];
    tmp.cleanOnBoot = true;
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    initrd = {
      kernelModules = ["nvme" "dm-snapshot"];
      availableKernelModules = [
        "ahci"
        "ata_piix"
        "sd_mod"
        "uhci_hcd"
        "vmw_pvscsi"
        "xen_blkfront"
        "xhci_pci"
      ];
    };
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2d5aa5d0-e6c5-4b5d-b295-d5248da994fc";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8480-5FBB";
    fsType = "vfat";
  };
  fileSystems."/eth1" = {
    device = "/dev/disk/by-uuid/d674ba1d-dde0-4c8d-bdc7-0cb240d6de62";
    fsType = "ext4";
  };
  fileSystems."/eth2" = {
    device = "/dev/disk/by-uuid/c2c7cf35-dc97-4ca3-823f-1e892bcba6f5";
    fsType = "ext4";
  };
  fileSystems."/var/lib/microvms" = {
    device = "/dev/disk/by-uuid/06af31e6-7ac6-4066-a56b-9feaae14508b";
    fsType = "ext4";
  };
  swapDevices = [
    {device = "/dev/disk/by-uuid/d4b0d80e-d570-4d21-bbe4-0f31bd50cbcc";}
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
          IPv6SendRA = false;
        };
        dhcpServerConfig = {
          PoolOffset = 128;
          PoolSize = 64;
          EmitDNS = true;
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
      "12-microvm" = {
        matchConfig.Name = "vnet*";
        networkConfig.Bridge = "microvm";
      };
    };
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

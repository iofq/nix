{ self, ... }: {
  microvm.vms = {
    vm-test = {
      flake = self;
      updateFlake = "github:iofq/nix";
      config = {
        microvm.shares = [{
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
          tag = "ro-store";
          proto = "virtiofs";
        }];
        microvm.interfaces = [
        {
          type = "tap";
          id = "vm-test";
          mac = "02:00:00:00:00:01";
        }
        ];
        system.stateVersion = "23.11"; 
      };
    };
  };
}

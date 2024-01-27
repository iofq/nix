{ ... }: {
  microvm.vms = {
    vm-test = {
      config = {
        microvm.shares = [{
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
          tag = "ro-store";
          proto = "virtiofs";
        }];
        system.stateVersion = "23.11"; 
      };
    };
  };
}

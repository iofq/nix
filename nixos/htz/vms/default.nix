{ lib, pkgs, addressList, ... }:
let genVMConfig = { name, config ? {}, ro-store ? true }: {
  restartIfChanged = true;
  pkgs = pkgs;
  config = config // {
    microvm = {
      shares = lib.mkIf (ro-store == true) [{
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }];
      interfaces = [
        {
          type = "tap";
          id = name;
          mac = addressList.${name}.mac;
        }
      ];
    };
  } // import ./vmDefaults.nix { inherit name addressList; };
};
in {
  microvm.vms = {
    vm-test = genVMConfig {
      name = "vm-test";
      config = import ./vm-test.nix { inherit pkgs addressList; };
    };
  };
}

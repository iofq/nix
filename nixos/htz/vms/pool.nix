{
  system,
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.ethereum-nix.nixosModules.default];

  environment.systemPackages = with pkgs; [
    vim
    inputs.ethereum-nix.packages.${system}.rocketpool
    docker-compose
  ];
  environment.interactiveShellInit = ''
    alias rp='rocketpool --allow-root'
  '';
  virtualisation = {
    docker = {
      enable = true;
    };
  };
  microvm = {
    vcpu = 2;
    mem = 4096;
    volumes = [
      {
        image = "/var/lib/microvms/vm-pool/vm-pool-root.img";
        label = "vm-pool-root";
        mountPoint = "/";
        size = 40000;
      }
    ];
  };
}

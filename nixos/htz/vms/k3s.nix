{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    k3s
  ];
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--disable traefik"
    ];
  };
  networking.firewall = {
    allowedTCPPorts = [6443];
  };
  services.tailscale.enable = true;
  microvm = {
    vcpu = 2;
    mem = 4096;
    volumes = [
      {
        image = "/var/lib/microvms/vm-k3s/vm-k3s-root.img";
        label = "vm-pool-root";
        mountPoint = "/";
        size = 10000;
      }
    ];
  };
}

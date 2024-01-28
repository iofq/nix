{ addressList, ... }: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80];
    allowedUDPPorts = [];
    logRefusedConnections = true;
  };
  services.nginx.enable = true;
  services.nginx.virtualHosts."default_server" = {
    addSSL = false;
    enableACME = false;
  };
  system.stateVersion = "23.11";
}

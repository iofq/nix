{
  system,
  inputs,
  ...
}: {
  networking = {
    firewall = {
      allowedTCPPorts = [9000 30303];
      allowedUDPPorts = [9000 30303];
      logRefusedConnections = true;
      trustedInterfaces = ["microvm"];
    };
  };
  services.ethereum.geth.mainnet = {
    enable = true;
    package = inputs.ethereum-nix.packages.${system}.geth;
    openFirewall = false;
    args = {
      http = {
        enable = true;
        addr = "10.0.0.1";
      };
      authrpc.jwtsecret = "/etc/nixos/eth_jwt";
    };
  };
  services.ethereum.nimbus-beacon.mainnet = {
    enable = true;
    package = inputs.ethereum-nix.packages.${system}.nimbus;
    openFirewall = false;
    args = {
      user = "nimbus";
      jwt-secret = "/etc/nixos/eth_jwt";
      trusted-node-url = "https://sync.invis.tools";
      enr-auto-update = true;
      rest = {
        enable = true;
        address = "10.0.0.1";
      };
      light-client-data.max-periods = "3";
    };
  };
}

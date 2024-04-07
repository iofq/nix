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
      interfaces."tailscale0".allowedTCPPorts = [5052 8545];
    };
  };
  # virtualisation.oci-containers.containers = {
  # besu = {
  #   image = "hyperledger/besu:24.3-graalvm";
  #   ports = [
  #     "0.0.0.0:30303:30303"
  #     "0.0.0.0:30303:30303/udp"
  #     "100.79.221.28:8551:8551"
  #   ];
  #   volumes = [
  #     "/eth1/besu:/var/lib/besu"
  #     "/etc/nixos/eth_jwt:/var/lib/jwtsecret/jwt.hex"
  #   ];
  #   environment = {
  #     JAVA_OPTS = "\"-Xmx16192m\"";
  #   };
  #   cmd = [
  #     "--Xsnapsync-synchronizer-flat-db-healing-enabled=true"
  #     "--data-path=/var/lib/besu"
  #     "--data-storage-format=bonsai"
  #     "--engine-jwt-secret=/var/lib/jwtsecret/jwt.hex"
  #     "--engine-rpc-enabled"
  #     "--engine-rpc-port=8551"
  #     "--fast-sync-min-peers=3"
  #     "--nat-method=docker"
  #     "--network=mainnet"
  #     "--sync-mode=X_SNAP"
  #   ];
  # };
  services.ethereum.geth.mainnet = {
    enable = true;
    package = inputs.ethereum-nix.packages.${system}.geth;
    openFirewall = false;
    args = {
      http = {
        enable = true;
        addr = "0.0.0.0";
        vhosts = ["htz.tailc353f.ts.net"];
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
        address = "0.0.0.0";
      };
      light-client-data.max-periods = "3";
    };
  };
}

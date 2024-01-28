{
  system,
  ethereum-nix,
  ...
}: {
  services.ethereum.geth.mainnet = {
    enable = true;
    package = ethereum-nix.packages.${system}.geth;
    openFirewall = true;
    args = {
      http = {
        enable = false;
        api = ["net" "web3" "eth"];
      };
      authrpc.jwtsecret = "/etc/nixos/eth_jwt";
    };
  };
  services.nginx.enable = true;
  services.nginx.virtualHosts."contabo.10110110.xyz" = {
    addSSL = true;
    enableACME = true;
    root = "/var/www/fam";
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "cjriddz@protonmail.com";
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [];
    logRefusedConnections = true;
  };
  services.ethereum.nimbus-beacon.mainnet = {
    enable = true;
    package = ethereum-nix.packages.${system}.nimbus;
    openFirewall = true;
    args = {
      nat = "any";
      network = "mainnet";
      jwt-secret = "/etc/nixos/eth_jwt";
      trusted-node-url = "https://sync.invis.tools";
      el = ["http://127.0.0.1:8551"];
      listen-address = "0.0.0.0";
      tcp-port = 9000;
      udp-port = 9000;
      enr-auto-update = true;
      max-peers = "160";
      doppelganger-detection = true;
      history = "prune";
      graffiti = "yo";
      metrics = {
        enable = true;
        port = 5054;
        address = "127.0.0.1";
      };
      rest = {
        enable = true;
        port = 5052;
        address = "0.0.0.0";
        allow-origin = "*";
      };
      payload-builder = {
        enable = true;
        url = "http://localhost";
      };
      light-client-data = {
        serve = true;
        import-mode = "only-new";
        max-periods = "3";
      };
    };
  };
}

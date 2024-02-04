{
  system,
  inputs,
  ...
}: {
  services.ethereum.geth.mainnet = {
    enable = true;
    package = inputs.ethereum-nix.packages.${system}.geth;
    openFirewall = true;
    args = {
      authrpc.jwtsecret = "/etc/nixos/eth_jwt";
    };
  };
  services.ethereum.nimbus-beacon.mainnet = {
    enable = true;
    package = inputs.ethereum-nix.packages.${system}.nimbus;
    openFirewall = true;
    args = {
      user = "nimbus";
      jwt-secret = "/etc/nixos/eth_jwt";
      trusted-node-url = "https://sync.invis.tools";
      enr-auto-update = true;
      rest.enable = true;
      light-client-data.max-periods = "3";
    };
  };
}

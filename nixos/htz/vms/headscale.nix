{config, ...}: let
  domain = "ts.10110110.xyz";
in {
  services = {
    headscale = {
      enable = true;
      address = "0.0.0.0";
      port = 8080;
      serverUrl = "https://${domain}";
      dns = {baseDomain = "10110110.xyz";};
      settings = {logtail.enabled = false;};
    };

    services.nginx = {
      enable = true;
      virtualHosts.${domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.headscale.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
  system.stateVersion = "23.11";
}

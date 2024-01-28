{ name, addressList, ...}: {
  systemd.network = {
    enable = true;
    networks."20-lan" = {
      matchConfig.Type = "ether";
      networkConfig = {
        Address = [(addressList.${name}.ipv4 + addressList.${name}.subnet)];
        Gateway = "10.0.0.1";
        DNS = ["1.1.1.1"];
        IPv6AcceptRA = true;
        DHCP = "no";
      };
    };
  };
  services.openssh.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22];
    allowedUDPPorts = [];
    logRefusedConnections = true;
  };
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEV8yjC8g68hoIi5021A6MR0ggMy++8KjmtXMzyOir2c root@htz''
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU2TUxKyGKoZ68IG4hw23RmxVf72u5K9W0StkgTr0b2 e@t14'' ];
    };
    e = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEV8yjC8g68hoIi5021A6MR0ggMy++8KjmtXMzyOir2c root@htz''
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU2TUxKyGKoZ68IG4hw23RmxVf72u5K9W0StkgTr0b2 e@t14''
      ];
    };
  };
}

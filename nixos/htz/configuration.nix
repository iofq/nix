{ pkgs, addressList, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./vms
#./eth.nix
  ];
  environment.systemPackages = with pkgs; [
    vim
  ];
  networking = {
    hostName = "htz";
    domain = "";
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [];
      logRefusedConnections = true;
    };
    nat = {
      enable = true;
      forwardPorts = [ {
        proto = "tcp";
        sourcePort = 80;
        destination = addressList.vm-test.ipv4;
      } ];
    };
  };
  services.openssh.enable = true;
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHM4Zr0PFN7QdOG2aJ+nuzRCK6caulrpY6bphA1Ppl8Y e@t14''];
    };
    e = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      home = "/home/e";
      openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHM4Zr0PFN7QdOG2aJ+nuzRCK6caulrpY6bphA1Ppl8Y e@t14''];
    };
  };
  security.sudo.wheelNeedsPassword = false;
  nix.settings.trusted-users = ["e"];
  system.stateVersion = "23.11"; 
}

{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./vms.nix
    #./eth.nix
  ];
  environment.systemPackages = with pkgs; [
    nfs-utils
    vim
  ];
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = false;
  networking.hostName = "htz";
  networking.domain = "";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22];
    allowedUDPPorts = [];
    logRefusedConnections = true;
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
      packages = with pkgs; [
        vim
        htop
        tree
      ];
      openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHM4Zr0PFN7QdOG2aJ+nuzRCK6caulrpY6bphA1Ppl8Y e@t14''];
    };
  };
  security.sudo.wheelNeedsPassword = false;
  nix.settings.trusted-users = ["e"];
}

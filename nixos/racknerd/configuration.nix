{ inputs, pkgs, system, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./minecraft.nix
  ];
  environment.systemPackages = with pkgs; [
    nfs-utils
  ];
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = false;
  networking.hostName = "rknrd";
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
      openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU2TUxKyGKoZ68IG4hw23RmxVf72u5K9W0StkgTr0b2 e@t14'' ];
    };
    e = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
        vim
        htop
        tree
      ];
      openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU2TUxKyGKoZ68IG4hw23RmxVf72u5K9W0StkgTr0b2 e@t14'' ];
    };
  };
  security.sudo.wheelNeedsPassword = false;
  nix.settings.trusted-users = ["e"];
  system.stateVersion = "22.11"; 
}

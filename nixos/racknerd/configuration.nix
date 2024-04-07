{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./minecraft.nix
    inputs.ethereum-nix.nixosModules.default
  ];
  environment.systemPackages = with pkgs; [
    nfs-utils
    vim
    inputs.ethereum-nix.packages.${system}.rocketpool
    docker-compose
  ];
  environment.interactiveShellInit = ''
    alias rp='rocketpool --allow-root'
  '';
  virtualisation = {
    docker = {
      enable = true;
    };
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = false;

  networking = {
    hostName = "rknrd";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [];
      logRefusedConnections = true;
    };
  };

  services.openssh.enable = true;
  services.tailscale.enable = true;
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU2TUxKyGKoZ68IG4hw23RmxVf72u5K9W0StkgTr0b2 e@t14''];
    };
    e = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
      openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU2TUxKyGKoZ68IG4hw23RmxVf72u5K9W0StkgTr0b2 e@t14''];
    };
  };
  virtualisation.oci-containers.containers = {
    signal-api = {
      image = "bbernhard/signal-cli-rest-api:latest";
      ports = ["100.73.10.99:8080:8080"];
      volumes = [
        "/root/signal-cli:/home/.local/share/signal-cli"
      ];
    };
  };
  systemd.timers."signal-upload" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*:0/5";
      Unit = "signal-upload.service";
    };
  };
  systemd.services."signal-upload" = {
    script = ''
      ${pkgs.curl}/bin/curl -X GET -H "Content-Type application/json" 'http://rknrd.tailc353f.ts.net:8080/v1/receive/+14145029897' && ${pkgs.docker}/bin/docker run --rm --env-file=${config.sops.secrets."b2-photos-s3/env".path} -v /root/signal-cli/attachments:/root/data public.ecr.aws/aws-cli/aws-cli s3 mv /root/data/ s3://iofq-photos/signal --endpoint-url=https://s3.us-west-004.backblazeb2.com --recursive
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
  security.sudo.wheelNeedsPassword = false;
  nix.settings.trusted-users = ["e"];
  system.stateVersion = "22.11";
}

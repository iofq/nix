{
  config,
  pkgs,
  ...
}: {
  sops = {
    defaultSopsFile = ../../secrets/restic.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets = {
      "b2-minecraft/env" = {};
      "b2-minecraft/repo" = {};
      "b2-minecraft/password" = {};
      "b2-photos-s3/env" = {};
    };
  };
  services.restic.backups = {
    b2-minecraft = {
      initialize = true;
      environmentFile = config.sops.secrets."b2-minecraft/env".path;
      repositoryFile = config.sops.secrets."b2-minecraft/repo".path;
      passwordFile = config.sops.secrets."b2-minecraft/password".path;

      paths = [
        "/var/lib/minecraft"
      ];
      timerConfig = {
        OnCalendar = "00:05";
      };
      pruneOpts = [
        "--keep-daily 3"
        "--keep-weekly 1"
        "--keep-monthly 1"
      ];
    };
  };
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    declarative = true;
    package = "${pkgs.minecraft-server}";
    serverProperties = {
      white-list = true;
      server-port = 25565;
      gamemode = "survival";
      enable-command-block = "true";
      motd = "whaa";
      max-players = "10";
      view-distance = 16;
    };
    whitelist = {
      cjriddz = "cf36e5f7-6e7f-490a-ba76-65016338e7b4";
      k359 = "a5ccc07c-144d-4dd0-b07c-48c4d5302b58";
    };
  };
}

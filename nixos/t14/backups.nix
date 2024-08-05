{config, ...}: {
  sops = {
    defaultSopsFile = ../../secrets/restic.yaml;
    age.keyFile = "/home/e/.config/sops/age/keys.txt";
    secrets = {
      "b2-home/env" = {};
      "b2-home/repo" = {};
      "b2-home/password" = {};
    };
  };
  services.restic.backups = {
    b2-home = {
      initialize = true;
      environmentFile = config.sops.secrets."b2-home/env".path;
      repositoryFile = config.sops.secrets."b2-home/repo".path;
      passwordFile = config.sops.secrets."b2-home/password".path;

      paths = [
        "/home/e/backmeup"
        "/home/e/.ssh"
        "/home/e/.librewolf"
        "/home/e/.runelite"
      ];
      timerConfig = {
        OnCalendar = "01:00";
      };
      pruneOpts = [
        "--keep-daily 14"
        "--keep-monthly 6"
        "--keep-yearly 1"
      ];
    };
  };
}

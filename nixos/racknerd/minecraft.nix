{ pkgs, ... }: {
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
      motd = "yooooooooooo";
    };
    whitelist = {
      cjriddz = "cf36e5f7-6e7f-490a-ba76-65016338e7b4";
      k359 = "a5ccc07c-144d-4dd0-b07c-48c4d5302b58";
    };
  };

}

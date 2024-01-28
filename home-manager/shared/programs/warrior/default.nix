{
  pkgs,
  config,
  ...
}: {
  programs.taskwarrior = {
    enable = true;
    colorTheme = "solarized-dark-256";
  };

  home.packages = with pkgs; [
    timewarrior
  ];
  home.file."${config.xdg.dataHome}/task/hooks/on-modify.timewarrior" = {
    source = "${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior";
    executable = true;
  };
}

{pkgs, ... }:
{
  home.packages = with pkgs; [
    xdg-utils
  ];
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/chrome" = "librewolf.desktop";
      "video/mp4" = "librewolf.desktop";
      "video/mkv" = "librewolf.desktop";
      "image/jpeg" = "librewolf.desktop";
      "image/jpg" = "librewolf.desktop";
      "image/png" = "librewolf.desktop";
      "application/epub" = "librewolf.desktop";
      "application/pdf" = "librewolf.desktop";
    };
    associations.added = {
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/chrome" = "librewolf.desktop";
    };
  };
}

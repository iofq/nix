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
      "application/x-extension-htm" = "librewolf.desktop";
      "application/x-extension-html" = "librewolf.desktop";
      "application/x-extension-shtml" = "librewolf.desktop";
      "application/xhtml+xml" = "librewolf.desktop";
      "application/x-extension-xhtml" = "librewolf.desktop";
      "application/x-extension-xht" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
    associations.added = {
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/chrome" = "librewolf.desktop";
      "text/html" = "librewolf.desktop;";
      "application/x-extension-htm" = "librewolf.desktop;";
      "application/x-extension-html" = "librewolf.desktop;";
      "application/x-extension-shtml" = "librewolf.desktop;";
      "application/xhtml+xml" = "librewolf.desktop;";
      "application/x-extension-xhtml" = "librewolf.desktop;";
      "application/x-extension-xht" = "librewolf.desktop;";
    };
  };
}

{pkgs, ... }:
{
  home.packages = with pkgs; [
    xdg-utils
  ];
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "io.gitlab.librewolf-community.desktop";
      "x-scheme-handler/https" = "io.gitlab.librewolf-community.desktop";
      "x-scheme-handler/chrome" = "io.gitlab.librewolf-community.desktop";
      "video/mp4" = "io.gitlab.librewolf-community.desktop";
      "video/mkv" = "io.gitlab.librewolf-community.desktop";
      "image/jpeg" = "io.gitlab.librewolf-community.desktop";
      "image/jpg" = "io.gitlab.librewolf-community.desktop";
      "image/png" = "io.gitlab.librewolf-community.desktop";
      "application/epub" = "io.gitlab.librewolf-community.desktop";
      "application/pdf" = "io.gitlab.librewolf-community.desktop";
      "application/x-extension-htm" = "io.gitlab.librewolf-community.desktop";
      "application/x-extension-html" = "io.gitlab.librewolf-community.desktop";
      "application/x-extension-shtml" = "io.gitlab.librewolf-community.desktop";
      "application/xhtml+xml" = "io.gitlab.librewolf-community.desktop";
      "application/x-extension-xhtml" = "io.gitlab.librewolf-community.desktop";
      "application/x-extension-xht" = "io.gitlab.librewolf-community.desktop";
      "x-scheme-handler/about" = "io.gitlab.librewolf-community.desktop";
      "x-scheme-handler/unknown" = "io.gitlab.librewolf-community.desktop";
    };
    associations.added = {
      "x-scheme-handler/http" = "io.gitlab.librewolf-community.desktop";
      "x-scheme-handler/https" = "io.gitlab.librewolf-community.desktop";
      "x-scheme-handler/chrome" = "io.gitlab.librewolf-community.desktop";
      "text/html" = "io.gitlab.librewolf-community.desktop;";
      "application/x-extension-htm" = "io.gitlab.librewolf-community.desktop;";
      "application/x-extension-html" = "io.gitlab.librewolf-community.desktop;";
      "application/x-extension-shtml" = "io.gitlab.librewolf-community.desktop;";
      "application/xhtml+xml" = "io.gitlab.librewolf-community.desktop;";
      "application/x-extension-xhtml" = "io.gitlab.librewolf-community.desktop;";
      "application/x-extension-xht" = "io.gitlab.librewolf-community.desktop;";
    };
  };
}

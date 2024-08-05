{pkgs, ...}: {
  programs.taskwarrior = {
    enable = true;
    colorTheme = "solarized-dark-256";
  };
  home.packages = with pkgs; [
    ripgrep
    k9s
    kubectl
    python3
    p7zip
    gnumake
    go
    jq
    awscli
  ];
}

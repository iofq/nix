{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    k9s
    kubectl
    python3
    p7zip
    gnumake
    gcc
    go
  ];
}

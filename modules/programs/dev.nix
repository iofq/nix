{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    fluxcd
    k9s
    kubectl
    python3
    p7zip
    nodejs
    nodePackages.pnpm
    gnumake
    gcc
    go
  ];
}

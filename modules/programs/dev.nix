{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    fluxcd
    k9s
    kubectl
    python3
  ];
}

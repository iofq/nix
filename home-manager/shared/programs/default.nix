{ home-manager, config, lib, pkgs, ... }:
{
  imports = [
    ./dev
    ./nvim
    ./shell
    ./2fa
    ./warrior
  ];
}

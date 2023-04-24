{ username, pkgs, ... }:
{
    imports = ( import ../modules/programs );
    home = {
      inherit username;
      stateVersion = "22.11";
      packages = with pkgs; [
        htop
        appimage-run
        ripgrep
      ];
    };
    xdg.enable = true;
}

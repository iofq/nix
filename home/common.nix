{ inputs, pkgs, ... }:
{
  imports = ( import ../modules/programs );
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix = {
  settings = {
    auto-optimise-store = true;
  };
  package = pkgs.nixFlakes;
  registry.nixpkgs.flake = inputs.nixpkgs;
  extraOptions = ''
  experimental-features = nix-command flakes
  '';
  };
  home = {
    stateVersion = "22.11";
    packages = with pkgs; [
      pulseaudio
      pulsemixer
      alsa-utils
      appimage-run
      wireguard-tools
      spleen
    ];
  };

  xdg.enable = true;
  fonts.fontconfig.enable = true;
  systemd.user.startServices = "sd-switch";
}

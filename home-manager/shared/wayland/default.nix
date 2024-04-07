{pkgs, ...}: {
  imports = [
    ./librewolf
    ./alacritty
    ./sway
    ./hyprland
    ./xdg
    ./audio
  ];

  home.packages = with pkgs; [
    wdisplays
    wl-clipboard
    gammastep
    sway-contrib.grimshot
  ];
  programs.bemenu = {
    enable = true;
    settings = {
      ignorecase = true;
      fn = "UbuntuMono";
      prompt = "open";
    };
  };
}

{...}: {
  imports = [
    ./librewolf
    ./alacritty
    ./sway
    ./hyprland
    ./xdg
    ./audio
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

{pkgs, ...}: {
  home.packages = with pkgs; [
    pulseaudio
    pulsemixer
    alsa-utils
    mpv
  ];
}

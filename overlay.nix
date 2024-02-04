{pkgs, ...}: {
  steam = pkgs.writeShellScriptBin "steam" ''
    flatpak run com.valvesoftware.Steam -pipewire "$@"
  '';
}

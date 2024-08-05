{
  inputs,
  final,
  pkgs,
  ...
}: {
  steam = pkgs.writeShellScriptBin "steam" ''
    flatpak run com.valvesoftware.Steam -pipewire "$@"
  '';
  inherit (inputs.nvim.packages.${final.system}) full;
  inherit (inputs.tfa.packages.${final.system}) twofa;
}

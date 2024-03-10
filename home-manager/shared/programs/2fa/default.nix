{pkgs, ...}: {
  home.packages = with pkgs; [
    twofa
  ];
  programs.gpg = {
    enable = true;
    settings = {pinentry-mode = "loopback";};
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "tty";
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };
}

_: {
  programs.git = {
    enable = true;
    userEmail = "cjriddz@protonmail.com";
    userName = "iofq";
    delta = {
      enable = true;
      options = {
        side-by-side = true;
        line-numbers = true;
      };
    };
    extraConfig = {
      core.editor = "nvim";
    };
    signing = {
      key = "cjriddz@protonmail.com";
      signByDefault = true;
    };
    extraConfig.pull.rebase = true;
    aliases = {
      a = "add . -p";
      s = "status";
      f = "fetch";
      d = "diff";
      cm = "commit -m";
      rb = "rebase -i";
    };
  };
}

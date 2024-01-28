_: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    prefix = "C-a";
    escapeTime = 0;
    baseIndex = 1;
    # vi mode navigation
    customPaneNavigationAndResize = true;
    extraConfig = ''
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel 'xclip -sel clip -i'
      set -g status-right ""
      setw -g status-style 'bg=colour0 fg=colour7'
      setw -g window-status-current-format '[#P:#W*] '
    '';
  };
}

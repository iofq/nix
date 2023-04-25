{ homeDirectory, pkgs, ...}:
{
  imports = [
    (import ./tmux.nix)
  ];
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignorespace" ];
    historyIgnore = [
      "ls"
      "cd"
      ":q"
      "exit"
    ];
    shellAliases = {
      la = "ls -lahrt --color=auto";
      ll = "la";
      ":q" = "exit";
      mpv = "mpv --no-keepaspect-window";
      sus = "systemctl suspend";
      gitu = "git add . && git commit && git push";
      rcp = "rsync -avh --progress";

    };
    shellOptions = [
      "cmdhist"
      "globstar"
      "dirspell"
      "dotglob"
      "extglob"
      "cdspell"
      "histappend"
    ];
    bashrcExtra = ''
    export PROMPT_COMMAND="prompt_command;history -a"
    export PATH="/usr/local/go/bin:~/go/bin:~/.bin:~/.local/bin:$PATH"
    export GPG_2FA="cjriddz@protonmail.com"
    export MANPAGER="nvim +Man!"
    export EDITOR="nvim"
    [[ $- != *i* ]] && return
    function exists {
      type $1 >/dev/null 2>&1
    }

    function prompt_command {
      GIT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null | cut -c 1-10)
      [[ $GIT_BRANCH != "" ]] && \
      PS1="\[\033[38;5;1m\][\u@\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;7m\]\W\[$(tput sgr0)\]\[\033[38;5;1m\]]\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;3m\]($GIT_BRANCH)\[\033[38;5;7m\]\$\[$(tput sgr0)\] " || \
      PS1="\[\033[38;5;1m\][\u@\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;7m\]\W\[$(tput sgr0)\]\[\033[38;5;1m\]]\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;3m\]\[\033[38;5;7m\]\$\[$(tput sgr0)\] "
    }
    bind "set completion-ignore-case on"
    bind "set completion-map-case on"
    bind "set show-all-if-ambiguous on"
    bind "set menu-complete-display-prefix on"
    bind '"\t":menu-complete'
    bind '"\C-k": previous-history'
    bind '"\C-j": next-history'
    function cd {
      cmd="ls"
      builtin cd "$@" && $cmd
    }
    exists "kubectl" && source <(kubectl completion bash)
    '';
  };
  programs.fzf = {
    enable = true;
    fileWidgetCommand = "command find -L . -mindepth 1 -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' -prune";
  };
}
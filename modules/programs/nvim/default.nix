{ pkgs, ...}:
{
  xdg.configFile.nvim = {
    source = ../../../config/nvim;
    recursive = true;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ":luafile ~/.config/nvim/lua/init.lua";

    plugins = with pkgs.vimPlugins; [
      vim-commentary
      vim-surround
      toggleterm-nvim
      targets-vim
      indent-blankline-nvim
      vim-go
      vim-nix
      (nvim-treesitter.withPlugins 
      (
        plugins: with plugins; [
          tree-sitter-bash
          tree-sitter-c
          tree-sitter-dockerfile
          tree-sitter-go
          tree-sitter-javascript
          tree-sitter-json
          tree-sitter-lua
          tree-sitter-nix
          tree-sitter-php
          tree-sitter-python
          tree-sitter-yaml
        ]
        )
        )
        nvim-treesitter-textobjects
        leap-nvim
        telescope-nvim
      ];
    };
  }

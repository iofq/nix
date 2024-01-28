_: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        title = "alacritty";
        dynamic_padding = true;
        decorations = "none";
        padding = {
          x = 16;
          y = 16;
        };
        opacity = 1;
      };
      font = {
        normal = {
          family = "Spleen 32x64";
          style = "Medium";
        };
        size = 12;
        offset = {
          x = 1;
          y = 1;
        };
      };
      cursor = {
        style = "Block";
        unfocused_hollow = true;
      };
      colors = {
        draw_bold_text_with_bright_colors = true;
        primary = {
          background = "#090410";
          foreground = "#bababd";
        };
        normal = {
          black = "#090410";
          red = "#b02f30";
          green = "#037538";
          yellow = "#c59820";
          blue = "#2e528c";
          magenta = "#764783";
          cyan = "#277c8a";
          white = "#bababd";
        };
        bright = {
          black = "#95A5A6";
          red = "#b02f30";
          green = "#00853e";
          yellow = "#c59820";
          blue = "#2e528c";
          magenta = "#764783";
          cyan = "#277c8a";
          white = "#ECF0F1";
        };
        vi_mode_cursor = {
          text = "CellBackground";
          cursor = "#00CC22";
        };
      };
      keyboard.bindings = [
        {
          key = "Q";
          mode = "Vi";
          action = "ToggleViMode";
        }
        {
          key = "K";
          mode = "~Alt";
          mods = "Control|Shift";
          action = "ScrollPageUp";
        }
        {
          key = "J";
          mode = "~Alt";
          mods = "Control|Shift";
          action = "ScrollPageDown";
        }
      ];
    };
  };
}

{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    autotiling-rs
    gammastep
    grim
  ];
  systemd.user.services.autotiling = {
    Install = {
      WantedBy = [ "sway-session.target" ];
      PartOf = [ "graphical-session.target" ]; 
    };
    Service = {
      ExecStart = "${pkgs.autotiling-rs}/bin/autotiling-rs";
      Restart = "always";
      RestartSec = 5;
    };
  };
  services.gammastep = {
    enable = true;
    dawnTime = "6:00-8:00";
    duskTime = "20:00-22:00";
    latitude = 43.0;
    longitude = -89.0;
    temperature.day = 6000;
    temperature.night = 3500;
  };
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      terminal = "alacritty";
      focus = {
        followMouse = "no";
        mouseWarping = "container";
      };
      fonts = {
        names = [
          "Spleen 32x64"
        ];
        style = "Medium";
        size = 12.0;
      };
      window = {
        border = 1;
      };
      colors = {
        focused = {
          border = "#dddddd";
          background = "#285577";
          childBorder = "#dddddd";
          indicator = "#2e9ef4";
          text = "#ffffff";
        };
      };
      gaps = {
        smartBorders = "on";
      };
      modifier = "Mod4";
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in lib.mkOptionDefault {
        "${modifier}+x" = "kill";
        "${modifier}+space" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
        "${modifier}+bracketleft" = "exec --no-startup-id grimshot --notify  save area /tmp/scrot-$(date \"+%Y-%m-%d\"T\"%H:%M:%S\").png";
        "${modifier}+bracketright" = "exec --no-startup-id grimshot --notify  copy area";
      };
      bars = [
        {
          mode = "dock";
          position = "top";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          fonts = {
            names = [
              "Spleen 32x64"
            ];
            style = "Medium";
            size = 12.0;
          };
          colors = {
            statusline = "#666666";
            focusedWorkspace = {
              background = "#000000";
              border = "#666666";
              text = "#666666";
            };
            inactiveWorkspace = {
              background = "#000000";
              border = "#000000";
              text = "#666666";
            };
          };
        }
      ];
      input = {
        "type:keyboard" = {
          xkb_options = "caps:super";
          repeat_delay = "300";
          repeat_rate = "60";
        };
        "type:touchpad" = {
          natural_scroll = "enabled";
          accel_profile = "flat";
          tap = "enabled";
          tap_button_map = "lrm";
          dwt = "enabled";
          middle_emulation = "enabled";
        };
        "type:touch" = {
          events = "disabled";
        };
      };
      output = {
        "*" = {
          bg = "#000000 solid_color";
        };
      };
    };
  };
  programs.i3status = {
    enable = true;
    general = {
      colors = false;
      separator = " | ";
      output_format = "none";
    };
    modules = {
      "ipv6" = {
        enable = false;
      };
      "disk /" = {
        enable = false;
      };
      "tztime local" = {
        settings = {
          format = "%m-%d-%y %H:%M  ";
        };
      };
      "wireless _first_" = {
        settings = {
          format_down = "off";
          format_up = "%signal";
        };
      };
      "memory" =  {
        settings = {
          format = "%used";
          format_degraded = "%used";
          threshold_degraded = "1G";
        };
      };
      "battery all" =  {
        settings = {
          format = "%percentage%status %remaining";
          status_chr = "+";
          status_bat = "";
          status_full = "";
        };
      };
      "volume master" = {
        position = 3;
        settings = {
          format = "%volume";
          format_muted = "muted";
          device = "default";
        };
      };
      "ethernet _first_" = {
        enable = false;
      };
    };
  };
}

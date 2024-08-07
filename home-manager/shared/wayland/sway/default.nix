{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    autotiling-rs
  ];
  home.sessionVariables = {
    # needed for Sway and Firefox to play nice
    XDG_CURRENT_DESKTOP = "sway";
    MOZ_DBUS_REMOTE = 1;
  };
  systemd.user.services.autotiling = {
    Install = {
      WantedBy = ["sway-session.target"];
      PartOf = ["graphical-session.target"];
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
        inherit (config.wayland.windowManager.sway.config) modifier;
      in
        lib.mkOptionDefault {
          Prior = "nop";
          Next = "nop";
          "${modifier}+x" = "kill";
          "${modifier}+space" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
          "${modifier}+bracketleft" = "exec --no-startup-id grimshot --notify  save area /tmp/scrot-$(date \"+%Y-%m-%d\"T\"%H:%M:%S\").png";
          "${modifier}+bracketright" = "exec --no-startup-id grimshot --notify  copy area";
          "${modifier}+Shift+Ctrl+l" = "exec loginctl lock-session";
          "XF86MonBrightnessDown" = "exec light -U 10";
          "XF86MonBrightnessUp" = "exec light -A 10";
          "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
          "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
          "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
          "XF86Display" = "exec 'swaymsg \"output eDP-1 toggle\"'";
        };
      assigns = {
        "9" = [
          {class = "discord";}
          {class = "Signal";}
        ];
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
            background = "#090410";
            statusline = "#666666";
            focusedWorkspace = {
              background = "#090410";
              border = "#666666";
              text = "#666666";
            };
            inactiveWorkspace = {
              background = "#090410";
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
          pointer_accel = "0.4";
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
          bg = "#090410 solid_color";
        };
      };
    };
    extraConfig = ''
      bindswitch --reload --locked lid:on exec "[ $(swaymsg -t get_outputs | jq '. | length') -gt 1 ] && swaymsg output eDP-1 disable"
      bindswitch --reload --locked lid:off output eDP-1 enable
    '';
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
      "memory" = {
        settings = {
          format = "%used";
          format_degraded = "%used";
          threshold_degraded = "1G";
        };
      };
      "battery all" = {
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
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      color = "#764783";
      daemonize = true;
      clock = true;
      ignore-empty-password = true;
    };
  };
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${config.programs.swaylock.package}/bin/swaylock";
      }
      {
        event = "lock";
        command = "${config.programs.swaylock.package}/bin/swaylock";
      }
    ];
  };
  services.kanshi = {
    enable = true;
    profiles = {
      nodock = {
        outputs = [
          {
            criteria = "eDP-1";
          }
        ];
      };
      dock = {
        outputs = [
          {
            criteria = "HDMI-A-1";
            status = "enable";
            mode = "1920x1080@60Hz";
            position = "0,0";
          }
        ];
      };
      bothdock = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,1080";
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
            mode = "1920x1080@60Hz";
            position = "0,0";
          }
        ];
      };
    };
  };
}

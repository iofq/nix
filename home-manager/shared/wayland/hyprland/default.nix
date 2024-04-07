{pkgs, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    systemd.enable = true;
    extraConfig = ''
      monitor=,preferred,auto,1
    '';
    settings = {
      "$mod" = "SUPER";
      general = {
        gaps_in = 0;
        gaps_out = 0;
        layout = "master";
      };
      misc = {
        disable_hyprland_logo = true;
      };
      decoration = {
        blur = {
          enabled = false;
        };
        drop_shadow = "no";
      };
      animations = {
        enabled = "yes";
        bezier = "ease,0.22,1,0.35,1";
        animation = [
          "windows, 1, 1.5, ease, popin"
          "windowsOut, 1, 1.5, ease, popin"
          "border, 0, 1, default"
          "fade, 1, 1.5, ease"
          "workspaces, 1, 3, ease, slidefade"
        ];
      };
      master = {
        new_is_master = "no";
        no_gaps_when_only = 1;
      };
      input = {
        kb_options = "caps:super";
        repeat_delay = "300";
        repeat_rate = "60";

        float_switch_override_focus = 0;
        # follow_mouse = 0;
        accel_profile = "flat";
        sensitivity = 0.4;
        touchpad = {
          natural_scroll = true;
          tap_button_map = "lrm";
          middle_button_emulation = false;
        };
        touchdevice = {
          enabled = false;
        };
      };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      binde = [
        "$mod ALT, h, resizeactive, -50 0"
        "$mod ALT, l, resizeactive, 50 0"
        "$mod ALT, k, resizeactive, 0 50"
        "$mod ALT, j, resizeactive, 0 -50"
      ];
      bind =
        [
          "$mod, Return, exec, alacritty"
          "$mod, x, killactive"
          "$mod, f, fullscreen"
          "$mod SHIFT, Escape, exit"
          "$mod SHIFT, f, fakefullscreen"
          "$mod, Space, exec, ${pkgs.bemenu}/bin/bemenu-run"
          "$mod, t, togglefloating"
          "$mod, bracketleft, exec, grimshot --notify  save area /tmp/scrot-$(date \"+%Y-%m-%d\"T\"%H:%M:%S\").png"
          "$mod, bracketright, exec, grimshot --notify  copy area"
          "$mod SHIFT, q, exec, loginctl lock-session"
          ",XF86MonBrightnessDown, exec,  light -U 10"
          ",XF86MonBrightnessUp, exec, light -A 10"
          ",XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +1%"
          ",XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -1%"
          ",XF86AudioMute, exec,  pactl set-sink-mute @DEFAULT_SINK@ toggle"

          ## Movement
          "$mod, p, layoutmsg, swapwithmaster"
          "$mod, e, layoutmsg, orientationnext"
          "$mod, i, layoutmsg, addmaster"
          "$mod, d, layoutmsg, removemaster"
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"
          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, l, movewindow, r"
          "$mod SHIFT, k, movewindow, u"
          "$mod SHIFT, j, movewindow, d"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
              ]
            )
            10)
        );
      windowrulev2 = [
        "workspace 9, class:^(WebCord|webcord|Webcord)$"
        "workspace 9, class:^(Signal|signal)$"
        "tile, class:^(Minecraft|minecraft)$"
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"
      ];
    };
  };
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        "height" = 14;
        "spacing" = 8;
        "layer" = "top";
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "cpu"
          "memory"
          "network"
          "temperature"
          "pulseaudio"
          "battery"
          "clock"
          "tray"
        ];
        "hyprland/workspaces" = {
          disable-scroll = true;
        };
        "hyprland/window" = {
          max-length = 100;
        };
        "clock" = {
          "format" = "{:%m-%d-%y %H:%M}";
        };
        "cpu" = {
          "format" = "{load} \@{avg_frequency}Ghz";
        };
        "memory" = {
          "format" = "{used}G";
        };
        "temperature" = {
          "thermal-zone" = 2;
          "hwmon-path" = "/sys/class/hwmon/hwmon0/temp1_input";
          "critical-threshold" = 80;
          "format-critical" = "!{temperatureC}°C";
          "format" = "{temperatureC}°C";
        };
        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {time}";
          "format-charging" = "+{capacity}% {time}";
          "format-plugged" = "+{capacity}%";
        };
        "network" = {
          "format-wifi" = "{signaldBm}db";
          "format-ethernet" = "{ifname}";
          "format-disconnected" = "";
          "tooltip" = "{ifname} = {ipaddr}/{cidr}";
          on-click = "${pkgs.hyprland}/bin/hyprctl dispatch exec \"[float] alacritty -e nmtui\"";
        };
        "pulseaudio" = {
          "format" = "{volume}%";
          on-click = "${pkgs.hyprland}/bin/hyprctl dispatch exec \"[float] alacritty -e pulsemixer\"";
        };
      };
    };
    style = ''
      * {
        font-family: "Spleen 32x64", "UbuntuMono Nerd Font";
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background: #090410;
        color: #bababd;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces {
      }

      #window {
        margin: 2px;
        padding-left: 8px;
        padding-right: 8px;
        background-color: #090410;
      }

      button {
        border: none;
        border-radius: 0;
      }

      button:hover {
        background: inherit;
        border-top: 2px solid #bababd;
      }

      #workspaces button {
        padding: 0 4px;
        background-color: #090410;
        color: #666666;
      }

      #workspaces button.active {
        background-color: #090410;
        color:#bababd;
        border-top: 2px solid #bababd;
      }

      #workspaces button.urgent {
        background-color: #eb4d4b;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #tray
      {
        padding: 2px;
        background-color: #090410;
        border-top: 2px solid #666666;
        color: #bababd;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }

      #battery.critical:not(.charging) {
        background-color: #f53c3c;
        color: #ffffff;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      label:focus {
        background-color: #090410;
      }

      #temperature.critical {
        background-color: #eb4d4b;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #eb4d4b;
      }
    '';
  };
}

{ polybar-pulseaudio-control
, ...
}:
{ config, pkgs, lib, osConfig, ... }:
{
  options.modules.gui.desktop-environment.sway.enable = lib.mkEnableOption ''
    Enable personal desktop-environment config (xmonad, polybar etc.)
  '';

  config = lib.mkIf config.modules.gui.desktop-environment.sway.enable {
    xdg.configFile."workstyle/config.toml".source = (pkgs.formats.toml { }).generate "workstyle-config" {
      alacritty = "";
      github = "";
      rust = "";
      google = "";
      firefox = "";
      chrome = "";
      chromium = "";
      nnn = "";
      "file manager " = "";
      "libreoffice calc" = "󱎏";
      "libreoffice writer" = "";
      libreoffice = "󰏆";
      nvim = "";
      gthumb = "";
      menu = "󰍜";
      calculator = "";
      transmission = "";
      qbittorrent = "";
      videostream = "";
      mpv = "";
      music = "󰝚";
      "disk usage" = "";
      ".pdf" = "";
      steam = "󰓓";
      heroic = "󰊗";
      games = "󰊗";
      corectrl = "";
      godot = "";
      blender = "󰂫";
      wine = "󰡶";
      discord = "󰙯";
      mattermost = "󰭹";
      thunderbird = "";
      other = {
        fallback_icon = "󰘔";
      };
    };
    programs.swaylock.enable = true;

    home.packages = with pkgs; [
      pulseaudio
    ] ++ (if osConfig.modules.hosts.isLaptop then [ brightnessctl wlsunset ] else [ ]);

    wayland.windowManager.sway = {
      enable = true;
      extraSessionCommands = ''
        export XDG_SESSION_TYPE=wayland
        export SDL_VIDEODRIVER=wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
        export QT_QPA_PLATFORM=wayland
        export XDG_CURRENT_DESKTOP=sway
        export NIXOS_OZONE_WL=1
        export MOZ_ENABLE_WAYLAND=1
      '';
      config = {
        modifier = "Mod4";
        terminal = "alacritty";
        window = {
          titlebar = false;
        };
        startup = [
          { command = "${pkgs.workstyle}/bin/workstyle"; always = true; }
        ];
        bars = [
          {
            command = "${pkgs.waybar}/bin/waybar";
            fonts = {
              names = [ "Fira Code" "Nerdfonts" ];
              style = "Bold Semi-Condensed";
              size = 12.0;
            };
          }
        ];
        output = builtins.listToAttrs (map (d: { name = d.wname; value = { adaptive_sync = if (d.vrr == "on") then "on" else "off"; pos = d.posx + " " + d.posy; mode = d.mode + "@" + d.rate + "Hz"; }; }) osConfig.modules.hosts.display.outputs);
        input = {
          "type:keyboard" = {
            xkb_layout = "us";
            xkb_variant = "altgr-intl";
            xkb_options = "caps:escape";
          };
          "type:mouse" = {
            scroll_factor = "3.0";
            pointer_accel = "0.0";
          };
          "type:touchpad" = {
            tap = "enabled";
            tap_button_map = "lmr";
            natural_scroll = "disabled";
            dwt = "enabled";
            accel_profile = "flat";
          };
        };
        workspaceOutputAssign = builtins.concatMap (d: map (w: { output = d.wname; workspace = builtins.toString w; }) d.workspaces) osConfig.modules.hosts.display.outputs;
        keybindings =
          let
            modifier = config.wayland.windowManager.sway.config.modifier;
          in
          lib.mkOptionDefault {
            "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
            "${modifier}+c" = "exec ${pkgs.firefox}/bin/firefox";
            "${modifier}+Shift+q" = "kill";
            "${modifier}+d" = "exec wofi --show drun";
            "${modifier}+0" = "workspace number 0";
            "${modifier}+Shift+0" = "move container to workspace number 0";
          };
      };
    };
    stylix.targets.waybar.enable = false;
    stylix.targets.swaylock.enable = true;
    stylix.targets.sway.enable = true;
    programs.waybar = with config.lib.stylix.colors.withHashtag; {
      enable = true;
      style = ''
            @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
            @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};
            @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
            @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};

        @keyframes blink-warning {
            70% {
                color: @base09;
            }

            to {
                color: @base09;
                background-color: @base0D;
            }
        }

        @keyframes blink-critical {
            70% {
              color: @base09;
            }

            to {
                color: @base09;
                background-color: @base0B;
            }
        }


        /* -----------------------------------------------------------------------------
         * Styles
         * -------------------------------------------------------------------------- */

        /* COLORS */

        /* Reset all styles */
        * {
            border: none;
            border-radius: 3px;
            min-height: 0;
            margin: 0.2em 0.3em 0.2em 0.3em;
        }

        /* The whole bar */
        #waybar {
            background: @base00;
            color: @base09;
            font-family: Fira Code, Nerdfonts;
            font-size: 12px;
            font-weight: bold;
        }

        /* Each module */
        #battery,
        #clock,
        #cpu,
        #custom-layout,
        #memory,
        #mode,
        #network,
        #pulseaudio,
        #temperature,
        #custom-alsa,
        #custom-pacman,
        #custom-weather,
        #custom-gpu,
        #tray,
        #backlight,
        #language,
        #custom-cpugovernor {
            padding-left: 0.6em;
            padding-right: 0.6em;
        }

        /* Each module that should blink */
        #mode,
        #memory,
        #temperature,
        #battery {
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        /* Each critical module */
        #memory.critical,
        #cpu.critical,
        #temperature.critical,
        #battery.critical {
            color: @base0B;
        }

        /* Each critical that should blink */
        #mode,
        #memory.critical,
        #temperature.critical,
        #battery.critical.discharging {
            animation-name: blink-critical;
            animation-duration: 2s;
        }

        /* Each warning */
        #network.disconnected,
        #memory.warning,
        #cpu.warning,
        #temperature.warning,
        #battery.warning {
            background: @base0D;
            color: @base02;
        }

        /* Each warning that should blink */
        #battery.warning.discharging {
            animation-name: blink-warning;
            animation-duration: 3s;
        }

        #mode { /* Shown current Sway mode (resize etc.) */
            color: @base09;
            background: @base02;
        }

        #workspaces button {
            font-weight: bold; /* Somewhy the bar-wide setting is ignored*/
            padding: 0;
            opacity: 0.3;
            background: none;
            font-size: 1em;
        }

        #workspaces button.focused {
            background: @base03;
            color: @base09;
            opacity: 1;
            padding: 0 0.4em;
        }

        #workspaces button.urgent {
            border-color: @base03;
            color: @base09;
            opacity: 1;
        }

        #window {
            margin-right: 40px;
            margin-left: 40px;
            font-weight: normal;
        }
        #bluetooth {
            background: @base02;
            font-size: 1.2em;
            font-weight: bold;
            padding: 0 0.6em;
        }

        #network {
            background: @base02;
        }

        #memory {
            background: @base02;
        }

        #cpu {
            background: @base02;
            color: @base09;
        }

        #temperature {
            background-color: @base02;
            color: @base09;
        }
        #temperature.critical {
            background:  @base0B;
        }
        #custom-layout {
            background: @base02;
        }

        #battery {
            background: @base02;
        }

        #backlight {
            background: @base02;
        }

        #custom-redshift {
            background: @base02;
        }

        #clock {
            background: @base02;
            color: @base09;
        }
        #clock.date {
            background: @base02;
        }

        #clock.time {
            background: @base02;
        }

        #pulseaudio { 
            background: @base02;
            color: @base09;
        }

        #pulseaudio.muted {
            background: @base0B;
            color: @base09;
        }
        #pulseaudio.source-muted {
            background: @base0B;
            color: @base09;
        }
        #tray {
            background: @base02;
        }
      '';
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 36;
          modules-left = [
            "clock"
            "backlight"
            (if osConfig.modules.hosts.isLaptop then "custom/redshift" else null)
            "memory"
            "cpu"
            "temperature"
          ];
          output = map (b: b.wname) (builtins.filter (d: d.bar == true) osConfig.modules.hosts.display.outputs);
          modules-center = [ "sway/workspaces" ];
          modules-right = [ "pulseaudio" (if osConfig.modules.hosts.isLaptop then "battery" else null) "network" "tray" ];
          "sway/workspaces" = {
            format = "{icon}";
            icon-size = 18;
            disable-scroll = true;
            all-outputs = false;
          };
          tray = {
            spacing = 15;
          };
          clock = {
            format = "{:%H:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
          backlight = {
            format = "{icon} {percent}%";
            format-icons = [ "󰃜" "󰃛" "" ];
          };
          "custom/redshift" = {
            format = " {}  ";
            interval = "once";
            exec = "if pgrep -x 'wlsunset' > /dev/null; then echo '󰖔'; else echo ''; fi";
            on-click = "if pgrep -x 'wlsunset' > /dev/null; then pkill wlsunset > /dev/null; else ${pkgs.wlsunset}/bin/wlsunset > /dev/null; fi";
          };
          memory = {
            states = {
              good = 0;
              warning = 60;
              critical = 80;
            };
            interval = 5;
            format = " {}%";
          };
          cpu = {
            states = {
              good = 0;
              warning = 70;
              critical = 95;
            };
            interval = 1;
            format = " {usage}%";
          };
          pulseaudio = {
            format = "{icon} {volume}%";
            format-bluetooth = "{icon} {volume}%";
            format-bluetooth-muted = "  {volume}";
            format-muted = " {icon} {volume}";
            format-icons = {
              "alsa_output.usb-Logitech_G533_Gaming_Headset-00.analog-stereo" = "󰋎";
              "alsa_output.pci-0000_10_00.3.analog-stereo" = "󰓃";
              headphone = "󰋋";
              hands-free = "󱡏";
              Headset = "󰋎";
              headset = "󰋎";
              hdmi = "󰽟";
              speaker = "󰓃";
              phone = "";
              portable = "";
              car = "";
              default = "󰓃";
            };
            on-click = "${polybar-pulseaudio-control}/pulseaudio-control.bash next-node";
            on-click-middle = "${polybar-pulseaudio-control}/pulseaudio-control.bash togmute";
            on-click-right = "exec pavucontrol &";
            on-scroll-up = "${polybar-pulseaudio-control}/pulseaudio-control.bash up";
            on-scroll-down = "${polybar-pulseaudio-control}/pulseaudio-control.bash down";
          };
          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ipaddr}/{cidr} 󰈀";
            format-disconnected = "󰈂";
            tooltip-format = "{ifname} via {gwaddr} 󰈀";
            tooltip-format-wifi = "{essid} ({signalStrength}%) ";
            tooltip-format-ethernet = "{ifname} ";
            tooltip-format-disconnected = "Disconnected";
            max-length = "50";
          };
          battery = {
            bat = "BAT0";
            interval = 60;
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon}  {capacity}%";
            format-icons = [ "" "" "" "" "" ];
          };
          "wlr/taskbar" = {
            "all-outputs" = true;
            format = "{app_id}";
            icon-theme = "Nerdfonts";
            "icon-size" = 15;
            on-click = "activate";
            "markup" = true;
            "max-length" = 7;
            on-click-right = "minimize";
            "on-click-middle" = "close";
          };
        };
      };
    };

    services.swayidle = {
      enable = true;
      timeouts = [
        { timeout = 1800; command = "${pkgs.swaylock}/bin/swaylock"; }
        { timeout = 2000; command = "swaymsg 'output * dpms off'"; }
      ];
      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock"; }
        { event = "lock"; command = "lock"; }
      ];
    };

    programs.wofi = {
      enable = true;
      style = (builtins.readFile ./wofi/style.css);
      settings = {
        width = "1280";
        height = "720";
        prompt = "";
        allow_images = true;
        allow_markup = true;
        term = "alacritty";
        hide_scroll = true;
        insensitive = true;
        image_size = 24;
      };
    };

    programs.swaylock.settings = {
      ignore-empty-password = true;
      daemonize = true;
      show-failed-attempts = true;
      scaling = "fill";
      indicator-idle-visible = true;
      indicator-radius = 256;
      indicator-thickness = 256;
      indicator-caps-lock = true;
    };
  };
}


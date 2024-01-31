{ config, pkgs, lib, ... }:
{
  options.modules.gui.desktop-environment.i3.enable = lib.mkEnableOption ''
    Enable personal desktop-environment config (xmonad, polybar etc.)
  '';


  options.wayland.windowManager.i3.desktopSession = lib.mkOption {
    type = lib.types.package;
    default = let sessionName = "i3"; in pkgs.writeTextFile
      {
        name = sessionName;
        destination = "/share/wayland-sessions/${sessionName}.desktop";
        text = ''
            [Desktop Entry]
            Version=1.0
            Name=${sessionName}
            Type=Application
            Exec=${pkgs.writeShellScriptBin sessionName ''
              . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
              if [ -e "$HOME/.profile" ]; then
                . "$HOME/.profile"
              fi
              systemctl --user stop graphical-session.target graphical-session-pre.target
              systemctl --user start graphical-session.target
              systemctl --user start graphical-session-pre.target
              startx
              systemctl --user stop graphical-session.target
              systemctl --user stop graphical-session-pre.target
              unset __HM_SESS_VARS_SOURCED
          ''}/bin/${sessionName}
        '';
      } // {
      providedSessions = [ sessionName ];
    };
  };

  config = lib.mkIf config.modules.gui.desktop-environment.i3.enable {
    home.file.".xinitrc".text = ''
      if [ -d /etc/x11/xinit/xinitrc.d ] ; then
          for f in /etc/x11/xinit/xinitrc.d/?* ; do
              [ -x "$f" ] && . "$f"
          done
          unset f
      fi

      exec i3
    '';

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
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "alacritty";
        window = {
          titlebar = false;
        };
        startup = [
          { command = "${pkgs.workstyle}/bin/workstyle"; always = true; }
        ];
        workspaceOutputAssign = [
          { workspace = "0"; output = "HDMI-A-0"; }
          { workspace = "8"; output = "HDMI-A-0"; }
          { workspace = "1"; output = "DisplayPort-1"; }
          { workspace = "2"; output = "DisplayPort-2"; }
          { workspace = "3"; output = "DisplayPort-1"; }
          { workspace = "4"; output = "DisplayPort-2"; }
          { workspace = "5"; output = "DisplayPort-1"; }
          { workspace = "6"; output = "DisplayPort-2"; }
          { workspace = "7"; output = "DisplayPort-1"; }
          { workspace = "9"; output = "DisplayPort-1"; }
        ];
        bars = [
          {
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
            position = "top";
            fonts = {
              names = [ "Fira Code" "Nerdfonts" ];
              style = "Bold Semi-Condensed";
              size = 12.0;
            };
          }

        ];
        keybindings =
          let
            modifier = config.wayland.windowManager.sway.config.modifier;
          in
          lib.mkOptionDefault {
            "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
            "${modifier}+c" = "exec ${pkgs.firefox}/bin/firefox";
            "${modifier}+Shift+q" = "kill";
            "${modifier}+d" = "exec rofi -show drun";
            "${modifier}+0" = "workspace number 0";
            "${modifier}+Shift+0" = "move container to workspace number 0";
          };
      };
    };

    programs.autorandr = {
      enable = true;
      profiles = {
        "default" = {
          fingerprint = {
            DP-2 = "00ffffffffffff0026cd187614020000071f0104b54627783f7675a754509b26125054bfef00d1c081803168317c4568457c6168617c565e00a0a0a0295030203500b9882100001e40e7006aa0a0675008209804b9882100001a000000fc00504c33323636510a2020202020000000fd003090e6e63c010a202020202020015502033af14b0103051404131f120211902309070783010000e200d565030c0020006d1a000002013090000000000000e305c301e60607015f5f2c93be006aa0a0555008209804b9882100001e409d006aa0a0465008209804b9882100001e023a801871382d40582c4500b9882100001e00000000000000000000000000000028";
            DP-3 = "00ffffffffffff001e6d095b8c0503000c1a0104b53c22789f3035a7554ea3260f50542108007140818081c0a9c0d1c08100010101014dd000a0f0703e803020650c58542100001a286800a0f0703e800890650c58542100001a000000fd00283d878738010a202020202020000000fc004c4720556c7472612048440a2001a60203117144900403012309070783010000023a801871382d40582c450058542100001e565e00a0a0a029503020350058542100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c8";
            HDMI-1 = "00ffffffffffff0004721602cdfe10353317010380351e78cabb04a159559e280d5054bfef80714f8140818081c081009500b300d1c0023a801871382d40582c4500132b2100001e000000fd00384c1f5311000a202020202020000000fc0053323432484c0a202020202020000000ff004c52393044303231383537370a012f020324f14f01020304050607901112131415161f230907078301000067030c001000382d023a801871382d40582c4500132b2100001f011d8018711c1620582c2500132b2100009f011d007251d01e206e285500132b2100001e8c0ad08a20e02d10103e9600132b21000018000000000000000000000000000000000000007e";
          };
          config = {
            DisplayPort-1 = {
              enable = true;
              crtc = 0;
              primary = true;
              position = "3840x0";
              mode = "2560x1440";
              rate = "143.91";
            };
            DisplayPort-2 = {
              enable = true;
              crtc = 0;
              primary = false;
              position = "0x0";
              mode = "3840x2160";
              rate = "60.00";
            };
            HDMI-A-0 = {
              enable = true;
              crtc = 0;
              primary = false;
              position = "6400x0";
              mode = "1920x1080";
              rate = "60.00";
            };
          };
        };
      };
    };

    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          blocks = [
            {
              alert = 10.0;
              block = "disk_space";
              info_type = "available";
              interval = 60;
              path = "/";
              warning = 20.0;
            }
            {
              block = "memory";
              format = " $icon mem_used_percents ";
              format_alt = " $icon $swap_used_percents ";
            }
            {
              block = "cpu";
              interval = 1;
            }
            {
              block = "load";
              format = " $icon $1m ";
              interval = 1;
            }
            {
              block = "sound";
            }
            {
              block = "time";
              format = " $timestamp.datetime(f:'%a %d/%m %R') ";
              interval = 60;
            }
          ];
        };
      };
    };

    stylix.targets.feh.enable = true;

    programs.rofi = {
      enable = true;
    };
    programs.feh.enable = true;
  };
}

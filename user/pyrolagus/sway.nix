{ config, pkgs, lib, ... }:

with lib;
{
  options.ucfg.graphical.sway.enable = mkOption {
    default = false;
    example = true;
  };

  config = mkIf config.ucfg.graphical.sway.enable {

    home.packages = with pkgs; [
      kanshi
      waybar
      nwg-displays
    ];

    wayland.windowManager.sway = {
      enable = true;
      swaynag.enable = true;
      systemd.enable = true;
      wrapperFeatures.gtk = true;
      config = {
        left = "n";
        down = "r";
        up = "t";
        right = "d";

        terminal = "${pkgs.wezterm}/bin/wezterm";

        input = {
          "type:keyboard" = {
            xkb_layout = "de,de,us";
            xkb_variant = "neo,,";
            xkb_options = "grp:ctrl_alt_toggle";
          };
          "type:touchpad" = {
            dwt = "enabled";
            tap = "enabled";
            natural_scroll = "enabled";
          };
          "type:touch" = {
            map_to_output = "eDP-1";
          };
          "type:tablet_tool" = {
            map_to_output = "eDP-1";
          };
        };

        output = {
          "*" = {
            bg = "${./wallpaper.jpg} fit";
          };

          #          eDP-1 = {
          #            pos = "0 1200";
          #          };

          #          HDMI-A-1 = {
          #            pos = "0 0";
          #          };
        };

        fonts = {
          names = [ "pango:monospace" ];
          size = 8.0;
        };

        modifier = "Mod4";

        keybindings =
          let
            cfg = config.wayland.windowManager.sway.config;
            modifier = config.wayland.windowManager.sway.config.modifier;
          in
          {
            "${modifier}+Return" = "exec ${cfg.terminal}";
            "${modifier}+Shift+q" = "kill";
            "${modifier}+s" = "exec ${pkgs.wofi}/bin/wofi --show run";

            "${modifier}+${cfg.left}" = "focus left";
            "${modifier}+${cfg.down}" = "focus down";
            "${modifier}+${cfg.up}" = "focus up";
            "${modifier}+${cfg.right}" = "focus right";

            "${modifier}+Left" = "focus left";
            "${modifier}+Down" = "focus down";
            "${modifier}+Up" = "focus up";
            "${modifier}+Right" = "focus right";

            "${modifier}+Shift+${cfg.left}" = "move left";
            "${modifier}+Shift+${cfg.down}" = "move down";
            "${modifier}+Shift+${cfg.up}" = "move up";
            "${modifier}+Shift+${cfg.right}" = "move right";

            "${modifier}+Shift+Left" = "move left";
            "${modifier}+Shift+Down" = "move down";
            "${modifier}+Shift+Up" = "move up";
            "${modifier}+Shift+Right" = "move right";

            "${modifier}+h" = "split h";
            "${modifier}+v" = "split v";
            "${modifier}+f" = "fullscreen toggle";
            "${modifier}+u" = "focus parent";

            "${modifier}+i" = "layout stacking";
            "${modifier}+a" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";

            "${modifier}+Shift+space" = "floating toggle";

            "${modifier}+j" = "sticky toggle";
            #"${modifier}+space" = "focus mode_toggle";

            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";
            "${modifier}+0" = "workspace number 10";

            "${modifier}+Shift+1" =
              "move container to workspace number 1";
            "${modifier}+Shift+2" =
              "move container to workspace number 2";
            "${modifier}+Shift+3" =
              "move container to workspace number 3";
            "${modifier}+Shift+4" =
              "move container to workspace number 4";
            "${modifier}+Shift+5" =
              "move container to workspace number 5";
            "${modifier}+Shift+6" =
              "move container to workspace number 6";
            "${modifier}+Shift+7" =
              "move container to workspace number 7";
            "${modifier}+Shift+8" =
              "move container to workspace number 8";
            "${modifier}+Shift+9" =
              "move container to workspace number 9";
            "${modifier}+Shift+0" =
              "move container to workspace number 10";

            "${modifier}+Shift+minus" = "move scratchpad";
            "${modifier}+minus" = "scratchpad show";

            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

            #"${modifier}+r" = "mode resize";

            "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+";
            "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-";
            "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "XF86AudioMicMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

            "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -d amdgpu_bl0 s 10%-";
            "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl -d amdgpu_bl0 s +10%";

            "Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot save output \"${config.home.homeDirectory}/Pictures/screenshots/\$(${pkgs.coreutils}/bin/date --iso-8601=ns).png\"";
            "Shift+Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";

            "${modifier}+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";
            "${modifier}+m" = "exec ${pkgs.wofi-emoji}/bin/wofi-emoji";
            "${modifier}+b" = "exec ${pkgs.wl-clipboard}/bin/wl-paste";

            "${modifier}+Shift+l" = "exec ${pkgs.procps}/bin/pkill -USR1 swayidle";

            "${modifier}+Space" = "exec ${pkgs.swayr}/bin/swayr switch-window";
          };

        window = {
          hideEdgeBorders = "smart";
        };

        bars = [ ];

        startup = [
          { command = "systemctl --user restart waybar"; always = true; }
          { command = "env RUST_BACKTRACE=1 RUST_LOG=swayr=debug ${pkgs.swayr}/bin/swayrd > /tmp/swayrd.log 2>&1"; }
        ];
      };

      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
    };

    services.swayidle =
      let
        lockCommand = "${pkgs.swaylock}/bin/swaylock -fF --image ${./wallpaper.jpg}";
      in
      {
        enable = true;
        events = [
          { event = "before-sleep"; command = lockCommand; }
          { event = "lock"; command = "lock"; }
        ];
        timeouts = [
          { timeout = 300; command = lockCommand; }
        ];
      };

    services.kanshi = {
      enable = true;
      profiles = {
        single = {
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1080@60Hz";
            }
          ];
        };
        infobib = {
          outputs = [
            {
              criteria = "eDP-1";
            }
            {
              criteria = "LTM HDMI TV 0x00006B90";
              mode = "1920x1080@60Hz";
            }
          ];
        };
      };
    };

    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          output = [ "eDP-1" ];
          modules-left = [ "sway/workspaces" "sway/mode" ];
          modules-center = [ "sway/window" ];
          modules-right = [ "idle_inhibitor" "pulseaudio" "gamemode" "memory" "network" "battery" "temperature" "clock" "tray" ];

          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              "1" = "一";
              "2" = "二";
              "3" = "三";
              "4" = "四";
              "5" = "五";
              "6" = "六";
              "7" = "七";
              "8" = "八";
              "9" = "九";
              "10" = "十";
            };
          };
        };
      };
    };

    services.mako = {
      enable = true;
      extraConfig = ''
        [urgency=critical]
        background-color=#ff2222
      '';
    };

    services.wlsunset = {
      enable = true;
      latitude = "49.0";
      longitude = "8.4";
      temperature = {
        day = 6500;
        night = 3000;
      };
    };
  };
}

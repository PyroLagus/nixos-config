{ config, pkgs, lib, nixpkgs, ... }:
{
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages =
        with pkgs; [
          alacritty
          brightnessctl
          font-awesome
          gnome.adwaita-icon-theme
          grim
          mako
          pinentry-gnome
          playerctl
          sarasa-gothic
          slurp
          sway-contrib.grimshot
          swayidle
          swaylock
          waybar
          wl-clipboard
          wofi
          xdg-desktop-portal-wlr

          (writeScriptBin "set-clamshell"
            ''
              #!/usr/bin/env bash
              if grep -q open /proc/acpi/button/lid/LID/state; then
                swaymsg output "$1" enable
              else
                swaymsg output "$1" disable
              fi
            '')
        ];
    };
  };

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      fira
      fira-code
      fira-code-symbols
      font-awesome
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      sarasa-gothic
      twitter-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Fira" ];
        sansSerif = [ "Fira" ];
        monospace = [ "Fira Code" "DejaVu Sans Mono" "Twitter Color Emoji" "Noto Color Emoji" "Sarasa Mono" ];
      };
    };
  };

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };

  hardware = {
    opengl = {
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        #rocm-opencl-icd
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
  boot.initrd.kernelModules = [ "amdgpu" ];
}

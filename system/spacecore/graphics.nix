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
          playerctl
          sarasa-gothic
          slurp
          sway-contrib.grimshot
          swayidle
          swayr
          swaylock
          waybar
          wl-clipboard
          wofi
          wtype
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
    #hyprland.enable = true;
  };

  fonts = {
    packages = with pkgs; [
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
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        #rocm-opencl-icd
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
      ];
    };
    opentabletdriver = {
      enable = false;
      daemon.enable = false;
    };
  };

  environment.pathsToLink = [ "/libexec" ];
  #services.xserver = {
  #  enable = true;
  #  desktopManager = {
  #    xterm.enable = false;
  #    runXdgAutostartIfNone = true;
  #  };
  #  displayManager.startx.enable = true;
  #windowManager.i3 = {
  #  enable = true;
  #  extraPackages = with pkgs; [
  #    dmenu
  #    i3status
  #    i3lock
  #  ];
  #};
  #};

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  #boot.initrd.kernelModules = [ "amdgpu" ];
}

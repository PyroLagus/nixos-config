# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, nixpkgs, ... }:

 {
  users.mutableUsers = false;

  hardware = {
    bluetooth.enable = true;
    nitrokey.enable = true;
  };

  # disable useless backlight service
  systemd.services."systemd-backlight@backlight:acpi_video0".enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "neo";
  };

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

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    mtr.enable = true;
    udevil.enable = true;
    dconf.enable = true;
    #ccache.enable = true;
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

  services = {
    # Enable earlyoom.
    earlyoom.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      wireplumber = {
        enable = true;
      };
    };
          
    #usbguard = {
    #  enable = true;
    #  rules = builtins.readFile ./secrets/system/usbguard_rules.conf;
    #};

    tlp.enable = true;
    upower.enable = true;
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

  # Required for pipewire.
  security.rtkit.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    agenix
    htop
    lm_sensors
    man-pages
    man-pages-posix
    ncdu
    nitrokey-app
    psmisc
    usbguard
    usbutils
    vim
    wget
  ];

  documentation = {
    dev.enable = true;
    man.generateCaches = true;
  };

  # Necessary for ZSH completion.
  environment.pathsToLink = [ "/share/zsh" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

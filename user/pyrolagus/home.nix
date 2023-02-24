{ config, pkgs, lib, ... }:

let
  username = "pyrolagus";
  nixos-config-path = "/home/${username}/.config/dotfiles/nixos-config";
in
{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  ucfg.graphical.sway.enable = true;

  xsession.windowManager.i3.enable = true;

  home.packages = with pkgs; [
    (discord.override { nss = nss_latest; })
    alacritty
    atool
    atuin
    blender
    bluez-tools
    eiskaltdcpp
    evince
    #factorio
    ghidra-bin
    godot
    godot-export-templates
    git-crypt
    helm
    hexchat
    imv
    inetutils
    inkscape
    krita
    ldtk
    libresprite
    libnotify
    lldb
    minecraft
    mitmproxy
    mosh
    neofetch
    nixpkgs-fmt
    obsidian
    passage
    age-plugin-yubikey
    rage
    passff-host
    pferd
    rr
    tdesktop
    termdown
    thunderbird
    vscode
    weechat
    wezterm
    wofi
    wofi-emoji
    xdg-utils
    xournalpp
    xsv
    yoshimi
    youtube-dl
    yt-dlp
    zam-plugins

    angband
    boohu
    brogue
    crawl
    crawlTiles
    #everspace
    harmonist
    hyperrogue
    infra-arcana
    ivan
    umoria
    nethack
    #nethack-qt
    unnethack
    cataclysm-dda-git
    keeperrl
    rogue
    sil
    sil-q
    tome4

    ahoviewer
    yacreader
    mcomix
    wireshark

    flips

    snes9x-gtk
    
    retroarchFull


    #(pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
    #  theme = "cla";
    #  enableIntro = false;
    #  enableFPS = true;
    #})
    #dwarf-therapist

    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" ];
    })
    rust-analyzer
    coq

    (writeScriptBin "system-flake-update"
      ''
        #!/bin/sh
        cd "$NIXOS_CONFIG_PATH"
        nix flake update --commit-lock-file
      '')

    (writeScriptBin "system-flake-rebuild"
      ''
        #!/bin/sh
        cd "$NIXOS_CONFIG_PATH"
        . "$(git --exec-path)/git-sh-setup"
        require_clean_work_tree "rebuild"
        nixos-rebuild switch --use-remote-sudo --flake "$NIXOS_CONFIG_PATH/#"
      '')
    (writeScriptBin "system-flake-test"
      ''
        #!/bin/sh
        nixos-rebuild test --use-remote-sudo --flake "$NIXOS_CONFIG_PATH/#"
      '')
    (writeScriptBin "system-flake-dry-activate"
      ''
        #!/bin/sh
        nixos-rebuild dry-activate --use-remote-sudo --flake "$NIXOS_CONFIG_PATH/#"
      '')
  ];

  home.sessionVariables = {
    NIXOS_CONFIG_PATH = nixos-config-path;
    LESS = "-R --use-color";
    BROWSER = "${pkgs.firefox}/bin/firefox";

    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.proof-general epkgs.exotica-theme ];
    extraConfig = ''
      (setq evilNormalColor "#D2527F") 
      (setq evilInsertColor "#2ABB9B")
      (setq evil-normal-state-cursor `((bar . 3) ,evilNormalColor)) 
      (setq evil-insert-state-cursor `((bar . 3) ,evilInsertColor))
 
      (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
      (set-face-attribute
        'spaceline-evil-normal nil :background evilNormalColor :foreground "black")
      (set-face-attribute
        'spaceline-evil-visual nil :background "#344256" :foreground "black")
      (set-face-attribute
        'spaceline-evil-insert nil :background evilInsertColor :foreground "black")
    '';
  };

  /*
    programs.vscode = {
    enable = true;
    userSettings = {
      "[nix]"."editor.tabSize" = 2;
    };
    };
  */

  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      ytdl-format = "bestvideo+bestaudio";
      alang = "ja, jap, eng, en, ger, de";
      gpu-context = "wayland";
    };
  };

  programs.zathura = {
    enable = true;
    extraConfig = ''
      set window-title-basename "true"
      set selection-clipboard "clipboard"

      # Dracula color theme for Zathura
      # Swaps Foreground for Background to get a light version if the user prefers

      #
      # Dracula color theme
      #

      set notification-error-bg       "#ff5555" # Red
      set notification-error-fg       "#f8f8f2" # Foreground
      set notification-warning-bg     "#ffb86c" # Orange
      set notification-warning-fg     "#44475a" # Selection
      set notification-bg             "#282a36" # Background
      set notification-fg             "#f8f8f2" # Foreground

      set completion-bg               "#282a36" # Background
      set completion-fg               "#6272a4" # Comment
      set completion-group-bg         "#282a36" # Background
      set completion-group-fg         "#6272a4" # Comment
      set completion-highlight-bg     "#44475a" # Selection
      set completion-highlight-fg     "#f8f8f2" # Foreground

      set index-bg                    "#282a36" # Background
      set index-fg                    "#f8f8f2" # Foreground
      set index-active-bg             "#44475a" # Current Line
      set index-active-fg             "#f8f8f2" # Foreground

      set inputbar-bg                 "#282a36" # Background
      set inputbar-fg                 "#f8f8f2" # Foreground
      set statusbar-bg                "#282a36" # Background
      set statusbar-fg                "#f8f8f2" # Foreground

      set highlight-color             "#ffb86c" # Orange
      set highlight-active-color      "#ff79c6" # Pink

      set default-bg                  "#282a36" # Background
      set default-fg                  "#f8f8f2" # Foreground

      set render-loading              true
      set render-loading-fg           "#282a36" # Background
      set render-loading-bg           "#f8f8f2" # Foreground

      #
      # Recolor mode settings
      #

      set recolor-lightcolor          "#282a36" # Background
      set recolor-darkcolor           "#f8f8f2" # Foreground

      #
      # Startup options
      #
      set adjust-open width
      set recolor true
    '';
  };

  programs.firefox.enable = true;

  programs.password-store.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
  };

  programs.nix-index.enable = true;

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
        "application/mp4" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
      };
    };
  };

  systemd.user.sessionVariables = {
    EDITOR = "hx";
  };
}

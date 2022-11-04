{ config, pkgs, lib, ... }:

let
  username = "pyrolagus";
  nixos-config-path = "/home/${username}/.config/dotfiles/nixos-config";

in {
  imports = [
    ./sway.nix
    ./terminal.nix
  ];

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  #accounts.email.accounts.main.himalaya.enable = true;
  #programs.himalaya.enable = true;

  home.packages = with pkgs; [
    ardour
    musescore
    rosegarden
    spotify
    
    atool
    atuin
    blender
    bluez-tools
    cadence
    carla
    (discord.override {nss = nss_latest;})

    comma
    niv
    nix-index

    bat
    bottom
    du-dust
    dutree
    fd
    hyperfine
    kalker
    sd
    skim
    tokei
    ripgrep-all
    himalaya
    rnote

    helix

    mc
    httpie
    khal
    unzip

    eiskaltdcpp
    
    ghidra-bin
    git-crypt
    helm
    helvum
    hexchat
    
    imv
    inetutils
    inkscape
    
    libnotify
    lldb
    lmms
    milkytracker
    minecraft
    mitmproxy
    mosh
    
    neofetch

    obsidian
    passff-host
    pavucontrol
    pferd
    qjackctl
    qsynth
    
    rr
    tdesktop
    termdown
    thunderbird
    
    weechat
    wofi
    wofi-emoji
    xdg-utils
    xournalpp
    xsv
    yoshimi
    youtube-dl
    yt-dlp
    
    zam-plugins

    alacritty
    wezterm

    factorio

    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))

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
  ];

  home.sessionVariables = {
    NIXOS_CONFIG_PATH = nixos-config-path;
    LESS = "-R --use-color";
    BROWSER = "${pkgs.firefox}/bin/firefox";

    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
  };

  programs.exa = {
    enable = true;
  };

  programs.direnv.enable = true;
  programs.emacs.enable = true;

  programs.git = {
    enable = true;
    userName = "Danny Bautista Sanchez";
    userEmail = "mail@pyrolagus.de";
    extraConfig = {
      init.defaultBranch = "main";
      submodule.recurse = true;
    };
  };

  programs.ssh = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
    userSettings = {
      "[nix]"."editor.tabSize" = 2;
    };
  };

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

  services.fluidsynth = {
    enable = true;
    soundService = "pipewire-pulse";
    extraOptions = [
      "--connect-jack-outputs"
      "--midi-driver=jack"
      "-o midi.autoconnect=1"
    ];
  };

  services.easyeffects = {
    enable = true;
  };

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

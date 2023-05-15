{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    asciinema
    bat
    bottom
    btop
    comma
    du-dust
    dutree
    fd
    helix
    himalaya
    #httpie
    hyperfine
    kalker
    #khal
    mc
    niv
    nix-index
    p7zip
    ripgrep
    ripgrep-all
    rnote
    sd
    skim
    tokei
    unrar
    unzip
    xplr
    vhs
    jq
    nurl
    neofetch
    hyfetch

    pynitrokey
  ];

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    shellAliases = {
      e = "exa";
      ns = "nix search nixpkgs";
      z = "zoxide";
    };

    envExtra = ''
      export EDITOR=${pkgs.helix}/bin/hx
    '';

    plugins = [{
      name = "atuin";
      src = pkgs.atuin.src;
    }];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

  programs.bat = {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 14;
    };
  };

  programs.zoxide.enable = true;

  programs.neovim = {
    enable = true;
    extraConfig = ''
      set tabstop=2
      set shiftwidth=2
      set expandtab
    '';
  };
  programs.exa = {
    enable = true;
  };
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
  programs.direnv.enable = true;
}

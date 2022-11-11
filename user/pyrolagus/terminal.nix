{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
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

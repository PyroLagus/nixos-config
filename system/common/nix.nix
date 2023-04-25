{ config, pkgs, lib, nixpkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      auto-optimise-store = true;
      substituters = [ "https://hydra.ist.nicht-so.sexy" ];
      trusted-public-keys = [ "hydra.ist.nicht-so.sexy-1:E+AwZnzYPdycs1IkHrlG0eJeBleAW/ukX10lcjTc2RQ="];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}

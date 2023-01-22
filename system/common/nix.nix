{ config, pkgs, lib, nixpkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      auto-optimise-store = true;
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

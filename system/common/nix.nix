{ config, pkgs, lib, nixpkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      auto-optimise-store = true;
      substituters = [ "https://hyprland.cachix.org" "https://cache.ngi0.nixos.org/" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
  };
}

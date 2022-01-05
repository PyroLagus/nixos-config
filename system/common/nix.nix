{ config, pkgs, lib, nixpkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      auto-optimise-store = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}

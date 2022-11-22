{ config, pkgs, lib, nixpkgs, ... }:
{
  imports = [
    ./audio.nix
    ./networking.nix
  ];
}

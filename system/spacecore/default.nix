{ config, pkgs, lib, nixpkgs, ... }:
{
  imports = [
    ./audio.nix
    ./ausweisapp.nix
    ./boot.nix
    ./configuration.nix
    ./gaming.nix
    ./graphics.nix
    ./hardware-configuration.nix
    ./networking.nix
  ];
}

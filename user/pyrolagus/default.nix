{ config, lib, nixpkgs, ... }:
{
  imports = [
    ./audio.nix
    ./home.nix
    ./sway.nix
    ./terminal.nix
  ];
}

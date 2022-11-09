{ config, lib, nixpkgs, ... }:
{
  imports = [
    ./home.nix
    ./sway.nix
    ./terminal.nix
  ];
}

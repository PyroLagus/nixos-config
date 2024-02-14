{ config, lib, nixpkgs, ... }:
{
  imports = [
    ./audio.nix
    #./email.nix
    ./home.nix
    ./sway.nix
    ./terminal.nix
  ];
}

{ config, pkgs, lib, nixpkgs, ... }:
{
  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  services.pcscd = {
    enable = true;
    plugins = with pkgs; [ ccid pcsc-cyberjack ];
  };
}
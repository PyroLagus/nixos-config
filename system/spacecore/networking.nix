{ config, pkgs, lib, nixpkgs, ... }:

{
  scfg.networking = {
    enable = true;
    interfaces = {
      "wlan0" = {
        hwAddress = "e4:aa:ea:f8:57:5f";
        required = true;
        isWireless = true;
      };

      "lan0" = {
        hwAddress = "a0:ce:c8:c9:54:03";
        required = false;
      };
    };
    zeroconf.enable = true;
  };

  hardware.bluetooth.enable = true;

  services.openssh.enable = true;

  networking.useNetworkd = true;

  networking.firewall.allowedTCPPorts = [ 3000 3001 ];
  networking.firewall.allowedUDPPorts = [ 3000 3001 ];
}

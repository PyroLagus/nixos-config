{ config, pkgs, lib, nixpkgs, ... }:

{
  scfg.networking = {
    enable = true;
    interfaces = {
      "wlan0" = {
        enable = false;
        hwAddress = "e4:aa:ea:f8:57:5f";
        required = true;
        isWireless = true;
      };

      "wlan1" =
        {
          hwAddress = "24:2f:d0:d9:30:cd";
          required = false;
          isWireless = true;
        };

      "lan0" = {
        hwAddress = "26:61:32:e6:33:3a";
        required = false;
      };
    };
    zeroconf.enable = true;
  };

  networking.interfaces.enp4s0f3u2 = {
    useDHCP = true;

  };

  hardware.bluetooth.enable = true;

  services.openssh.enable = true;

  networking.useNetworkd = true;

  programs.wireshark.enable = true;

  networking.firewall.allowedTCPPorts = [ 3000 3001 ];
  networking.firewall.allowedUDPPorts = [ 3000 3001 ];
}

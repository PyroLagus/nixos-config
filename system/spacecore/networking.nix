{ config, pkgs, lib, nixpkgs, ... }:

{
  pcfg.networking = {
    enable = true;
    interfaces = {
      "wlan0" = {
        hwAddress = "e4:aa:ea:f8:57:5f";
        required = true;
      };

      "lan0" = {
        hwAddress = "a0:ce:c8:c9:54:03";
        required = false;
      };
    };
  };

  hardware.bluetooth.enable = true;
  networking = {
    hostName = "spacecore";
    wireless = {
      enable = true;
      userControlled.enable = true;
    };
  };

  services = {
    resolved = {
      enable = true;
      dnssec = "true";
    };

    avahi = {
      enable = true;
      nssmdns = true;
    };

    openssh.enable = true;

    #dhcpd4.enable = true;
  };
}

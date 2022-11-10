{ config, pkgs, lib, nixpkgs, ... }:

{
  pcfg.networking = {
    enable = true;
    interfaces = {
      "wlan0" = {
        enable = true;
        hwAddress = "e4:aa:ea:f8:57:5f";
        required = true;
      };

      "lan0" = {
        enable = true;
        hwAddress = "a0:ce:c8:c9:54:03";
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

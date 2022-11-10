{ config, pkgs, lib, nixpkgs, ... }:

let
  wlanDevice = {
    name = "wlan0";
    address = "e4:aa:ea:f8:57:5f";
  };
  lanDevice = {
    name = "lan0";
    address = "a0:ce:c8:c9:54:03";
  };
in
{
  pcfg.networking = {
    enable = true;
    interfaces = {
      "wlan0" = {
        enable = true;
        hwAddress = "e4:aa:ea:f8:57:5f";
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

    # Use enable DHCP explicitly for each device.
    useDHCP = false;
    interfaces = {
      "${lanDevice.name}".useDHCP = true;
      "${wlanDevice.name}".useDHCP = true;
    };
  };

  systemd.services = {
    # don't require ethernet to be connected when booting
    "network-link-${lanDevice.name}".wantedBy = lib.mkForce [ ];
    "network-addresses-${lanDevice.name}".wantedBy = lib.mkForce [ ];
  };

/*
  systemd.network.links."10-lan" = {
    matchConfig.PermanentMACAddress = "${lanDevice.address}";
    linkConfig.Name = "${lanDevice.name}";
  };

  systemd.network.links."10-wlan" = {
    matchConfig.PermanentMACAddress = "${wlanDevice.address}";
    linkConfig.Name = "${wlanDevice.name}";
  };
*/

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

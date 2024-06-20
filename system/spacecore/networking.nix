{ config, pkgs, lib, nixpkgs, ... }:

{
  networking.networkmanager.enable = true;

  services = {
    resolved = {
      enable = true;
      dnssec = "true";
    };

    avahi = {
      enable = cfg.zeroconf.enable;
      nssmdns4 = cfg.zeroconf.enable;
    };
  };

  hardware.bluetooth.enable = true;

  services.openssh.enable = true;

  networking.useNetworkd = true;

  programs.wireshark.enable = true;

  networking.firewall.allowedTCPPorts = [ 3000 3001 ];
  networking.firewall.allowedUDPPorts = [ 3000 3001 ];
}

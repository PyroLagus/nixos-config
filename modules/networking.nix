{ config, pkgs, lib, nixpkgs, ... }:

with lib;

let
  cfg = config.scfg.networking;
  opt = options.scfg.networking;
  dbg = (exp: trace exp exp);
in
{
  options.scfg.networking.enable = mkOption {
    default = false;
    example = false;
  };

  options.scfg.networking.zeroconf.enable = mkOption {
    default = false;
    example = true;
  };

  config = mkIf cfg.enable {
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
  };
}

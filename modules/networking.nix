{ config, pkgs, lib, nixpkgs, ... }:

with lib;

let
  cfg = config.scfg.networking;
  opt = options.scfg.networking;
  enabledInterfaces = filterAttrs (n: v: v.enable) cfg.interfaces;
  optionalInterfaces = filterAttrs (n: v: !v.required) enabledInterfaces;
  dbg = (exp: trace exp exp);
in
{
  options.scfg.networking.enable = mkOption {
    default = true;
    example = false;
  };

  options.scfg.networking.interfaces = mkOption {
    type = types.attrsOf (types.submodule {
      options = {
        enable = mkOption {
          default = true;
          example = false;
        };
        hwAddress = mkOption {
          type = types.nullOr types.str;
          default = null;
        };
        required = mkOption {
          default = false;
          example = true;
        };
        isWireless = mkOption {
          default = false;
          example = true;
        };
      };
    });
  };

  options.scfg.networking.zeroconf.enable = mkOption {
    default = false;
    example = true;
  };

  config = mkIf cfg.enable {
    systemd.network.wait-online.anyInterface = true;
    systemd.network.links = (mapAttrs'
      (name: a: nameValuePair "10-${name}"
        {
          matchConfig.PermanentMACAddress = a.hwAddress;
          linkConfig.Name = name;
        }
      )
      (filterAttrs (n: v: v.hwAddress != null) enabledInterfaces));

    networking = {
      useDHCP = false;
      interfaces = (mapAttrs (name: a: { useDHCP = true; }) enabledInterfaces);
      wireless = let e = any (a: a.isWireless) (attrValues enabledInterfaces); in {
        enable = e;
        userControlled.enable = e;
      };
    };

    systemd.services = genAttrs
      (concatMap (name: ["network-link-${name}" "network-addresses-${name}"]) (attrNames optionalInterfaces))
      (name: { wantedBy = lib.mkForce []; });

    services = {
      resolved = {
        enable = true;
        dnssec = "true";
      };

      avahi = {
        enable = cfg.zeroconf.enable;
        nssmdns = cfg.zeroconf.enable;
      };
    };
  };
}

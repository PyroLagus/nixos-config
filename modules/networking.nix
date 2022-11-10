{ config, pkgs, lib, nixpkgs, ... }:

with lib;

let
  cfg = config.pcfg.networking;
  opt = options.pcfg.networking;
  interfaceList = mapAttrsToList (name: opts: opts // { inherit name; }) cfg.interfaces;
in
{
  options.pcfg.networking.enable = mkOption {
    default = true;
    example = false;
  };

  options.pcfg.networking.interfaces = mkOption {
    type = types.attrsOf (types.submodule {
      options = {
        enable = mkOption {
          default = false;
          example = true;
        };
        hwAddress = mkOption {
          type = types.nullOr types.str;
          default = null;
        };
      };
    });
  };

  config = {
    systemd.network.links = config.systemd.network.links // (mapAttrs' (name: a: {
      name = "10-${name}";
      value = {
        matchConfig.PermanentMACAddress = a.hwAddress;
        linkConfig.name = name;
      };
    }) (filterAttrs (n: v: v.enable && (v.hwAddress != null)) cfg.interfaces));
  };
}

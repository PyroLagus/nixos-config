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
        hwAddress = {
          type = types.nullOr types.str;
          default = null;
        };
      };
    });
  };

  config = {
    systemd.network.links = (mapAttrs (name: a: {
      "10-${name}" = mkIf (a.enable && (a.hwAddress != null)) {
        matchConfig.PermanentMACAddress = a.hwAddress;
        linkConfig.name = name;
      };
    }) cfg.interfaces);
  };
}

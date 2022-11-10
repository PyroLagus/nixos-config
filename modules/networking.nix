{ config, pkgs, lib, nixpkgs, ... }:

with lib;

let
  cfg = config.pcfg.networking;
  opt = options.pcfg.networking;
  enabledInterfaces = filterAttrs (n: v: v.enable) cfg.interfaces;
  optionalInterfaces = filterAttrs (n: v: !v.required) enabledInterfaces;
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
        required = mkOption {
          default = false;
          example = true;
        };
      };
    });
  };

  config = mkIf cfg.enable {
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
    };

    systemd.services =
    (mapAttrs'
      (name: a: nameValuePair "network-link-${name}" { wantedBy = lib.mkForce [ ]; }) optionalInterfaces) //
    (mapAttrs'
      (name: a: nameValuePair "network-address-${name}" { wantedBy = lib.mkForce [ ];}) optionalInterfaces);
    /*
    systemd.services = map (name: {
      "network-link-${name}".wantedBy = lib.mkForce [ ];
      "network-address-${name}".wantedBy = lib.mkForce [ ];
    }) (attrNames optionalInterfaces);
  };
  */
}

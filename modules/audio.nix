{ config, pkgs, lib, nixpkgs, ... }:
{
  options.scfg.audio.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.scfg.audio.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      wireplumber = {
        enable = true;
        package = pkgs.wireplumber.override { bluez = pkgs.bluezFull; };
      };
    };
    security.rtkit.enable = true;
  };
}

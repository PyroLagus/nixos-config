{ config, pkgs, lib, nixpkgs, ... }:
{
  options.pcfg.audio.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.pcfg.audio.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      wireplumber = {
        enable = true;
      };
    };
    security.rtkit.enable = true;
  };
}
{ config, pkgs, lib, nixpkgs, ... }:
{
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

  # Required for pipewire.
  security.rtkit.enable = true;
}
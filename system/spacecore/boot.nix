{ config, pkgs, lib, nixpkgs, ... }:
{
  boot = {
    # Configure partition encryption.
    initrd.luks = {
      devices.crypted.device = "/dev/disk/by-uuid/eb361451-65d8-4015-8d09-c38c369636c0";
      devices.crypted.preLVM = true;
    };

    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_zen;

    extraModulePackages = with config.boot.kernelPackages; [ zenpower v4l2loopback ];
    kernelModules = [ "zenpower" "v4l2loopback" ];
  };
}

{ config, pkgs, lib, nixpkgs, ... }:

{
  users.mutableUsers = false;

  hardware = {
    bluetooth.enable = true;
    nitrokey.enable = true;
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };

  # Disable useless backlight service
  systemd.services."systemd-backlight@backlight:acpi_video0".enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "neo";
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    mtr.enable = true;
    udevil.enable = true;
    dconf.enable = true;
  };

  services = {
    earlyoom.enable = true;
    printing.enable = true;

    #usbguard = {
    #  enable = true;
    #  rules = builtins.readFile ./secrets/system/usbguard_rules.conf;
    #};

    tlp.enable = true;
    upower.enable = true;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    agenix
    htop
    lm_sensors
    man-pages
    man-pages-posix
    ncdu
    nitrokey-app
    psmisc
    usbguard
    usbutils
    vim
    wget
  ];

  documentation = {
    dev.enable = true;
    man.generateCaches = true;
  };

  # Necessary for ZSH completion.
  environment.pathsToLink = [ "/share/zsh" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

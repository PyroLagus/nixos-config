{ config, pkgs, lib, nixpkgs, ... }:

{
  users.mutableUsers = false;
  networking.hostName = "spacecore";

  hardware.nitrokey.enable = true;

  users.groups.nitrokey = { };

  security.pam.u2f = {
    enable = true;
    control = "sufficient";
    authFile = config.age.secrets.u2f-mappings.path;
  };

  security.sudo-rs = {
    enable = true;
  };

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "nitrokey3-udev-rules";
      text = ''
        ACTION!="add|change", GOTO="u2f_end"
        # Nitrokey 3
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42b2", TAG+="uaccess"
        # Nitrokey 3 Bootloader
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42dd", TAG+="uaccess"
        # Nitrokey 3 Bootloader NRF
        ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42e8", TAG+="uaccess"
        LABEL="u2f_end"
      '';
      destination = "/etc/udev/rules.d/41-nitrokey3.rules";
    })
  ];

  # Disable useless backlight service
  systemd.services."systemd-backlight@backlight:acpi_video0".enable = false;

  systemd.services."remove-mimeapps.list-pyrolagus" = {
    wantedBy = [ "home-manager-pyrolagus.service" ];
    before = [ "home-manager-pyrolagus.service" ];
    description = "Removes pyrolagus' mimeapps.list so that home-manager may start correctly.";
    serviceConfig = {
      Type = "oneshot";
      User = "pyrolagus";
      ExecStart = ''${pkgs.coreutils}/bin/rm -f /home/pyrolagus/.config/mimeapps.list'';
    };
  };

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
    adb.enable = true;
    zsh.enable = true;
  };

  services = {
    printing.enable = true;
    tlp.enable = true;
    upower.enable = true;

    #usbguard = {
    #  enable = true;
    #  rules = builtins.readFile ./secrets/system/usbguard_rules.conf;
    #};
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    htop
    lm_sensors
    man-pages
    man-pages-posix
    ncdu
    nitrokey-app
    pam_u2f
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

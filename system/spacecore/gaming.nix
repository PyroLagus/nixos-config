{ config, pkgs, lib, nixpkgs, ... }:
{
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  
  services.udev.packages = [
      (pkgs.writeTextFile {
        name = "extra-steam-input-rules";
        text = ''
          # HORI Pokken Pad
          KERNEL=="hidraw*", ATTRS{idVendor}=="0f0d", ATTRS{idProduct}=="0092", MODE="0660", TAG+="uaccess"
        '';
        destination = "/etc/udev/rules.d/60-steam-input-extra.rules";
      })
  ];
}
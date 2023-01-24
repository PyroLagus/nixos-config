{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    ardour
    bambootracker
    cheesecutter
    #helvum
    musescore4.musescore
    rosegarden
    spotify
    cadence
    carla
    furnace
    hivelytracker
    klystrack
    littlegptracker
    lmms
    milkytracker
    pavucontrol
    qjackctl
    qsynth
    renoise
    schismtracker
    qpwgraph
    pw-viz
  ];

  services.fluidsynth = {
    enable = false;
    soundService = "pipewire-pulse";
    extraOptions = [
      "--connect-jack-outputs"
      "--midi-driver=jack"
      "-o midi.autoconnect=1"
    ];
  };

  services.easyeffects = {
    enable = false;
  };

  systemd.user.services.mpris-proxy = {
    Unit.Description = "Mpris proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  };
}

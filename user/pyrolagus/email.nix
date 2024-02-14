{ config, lib, nixpkgs, ... }:
{
  programs.himalaya.enable = true;

  accounts.email.accounts.main.himalaya = {
    enable = true;
    backend = "imap";
    sender = "smtp";
  };

  accounts.email.accounts.kit.himalaya = {
    enable = true;
    backend = "imap";
    sender = "smtp";
  };

  accounts.email.accounts.hadiko.himalaya = {
    enable = true;
    backend = "imap";
    sender = "smtp";
  };

  accounts.email.accounts.lila-pause.himalaya = {
    enable = true;
    backend = "imap";
    sender = "smtp";
  };
}

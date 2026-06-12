# crypto stands for cryptography, not cryptocurrency
{
  pkgs,
  lib,
  config,
  ...
}:
{
  environment.systemPackages =
    with pkgs;
    [
      gnupg
      opensc
      pinentry-curses

      rage
      age-plugin-yubikey
    ]
    ++ (lib.optional config.gensokyo.traits.gui pinentry-qt);

  programs.gnupg.agent.enable = true;
  # ideally this should be set automatically but in case that doesn't work
  #programs.gnupg.agent.pinentryFlavor = "curses"; # we don't have a gui.

  services.pcscd.enable = true;
}

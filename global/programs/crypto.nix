# crypto stands for cryptography, not cryptocurrency
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gnupg
    pinentry
    opensc

    rage
    age-plugin-yubikey
  ];

  programs.gnupg.agent.enable = true;
  # ideally this should be set automatically but in case that doesn't work
  #programs.gnupg.agent.pinentryFlavor = "curses"; # we don't have a gui.

  services.pcscd.enable = true;
}

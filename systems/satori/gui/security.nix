{pkgs, ...}: {
  services.yubikey-agent.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;
  # FIXME: fix yubikey-agent being stubborn
}

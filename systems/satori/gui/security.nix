{pkgs, ...}: {
  services.yubikey-agent-socket.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;
  # FIXME: fix yubikey-agent being stubborn

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };
}

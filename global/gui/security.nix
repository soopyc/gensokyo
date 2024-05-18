{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  services.yubikey-agent-socket.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;
  # FIXME: fix yubikey-agent being stubborn
}

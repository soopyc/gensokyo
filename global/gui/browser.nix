{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = lib.singleton pkgs.firefoxpwa;
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = lib.singleton pkgs.firefoxpwa;
    # package = pkgs.firefox-devedition;
  };
}

{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = [
    pkgs.sshfs
    pkgs.vscodium

    # school requirement
    pkgs.eclipses.eclipse-java
    pkgs.mars-mips
  ];
}

{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = [
    pkgs.vscode

    # school requirement
    pkgs.eclipses.eclipse-java
    pkgs.mars-mips
  ];
}

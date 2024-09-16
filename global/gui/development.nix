{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = [
    pkgs.vscode

    pkgs.eclipses.eclipse-java
    pkgs.mars-mips
  ];
}

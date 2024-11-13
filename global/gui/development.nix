{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = [
    pkgs.vscode
    pkgs.zed-editor

    # school requirement
    pkgs.eclipses.eclipse-java
    pkgs.mars-mips
  ];
}

{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-rime
      ];
    };
  };

  environment.systemPackages = [
    pkgs.showmethekey
  ];
}

{pkgs, ...}: {
  i18n.inputMethod = {
    enabled = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-rime
        
        fcitx5-nord
      ];
    };
  };
}

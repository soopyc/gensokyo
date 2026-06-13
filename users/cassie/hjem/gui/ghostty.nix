{
  lib,
  config,
  pkgs,
  ...
}:

lib.mkIf config.gensokyo.traits.gui (
  let
    # https://github.com/nix-community/home-manager/blob/release-26.05/modules/programs/ghostty.nix#L10
    format = pkgs.formats.keyValue {
      listsAsDuplicateKeys = true;
      mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
    };
  in
  {
    # systemd stuff moved to global/gui
    # ...except this i guess
    # ...this really should be a user-side override, maybe with hjem
    systemd.user.services."app-com.mitchellh.ghostty".reloadTriggers =
      lib.singleton
        config.hjem.users.cassie.xdg.config.files."ghostty/config".source;

    hjem.users.cassie.xdg.config.files."ghostty/config" = {
      generator = format.generate "ghostty-config";
      value = {
        custom-shader = toString ./ghostty-shaders/zoom_and_aberration.glsl;
        custom-shader-animation = true;
        font-family = "Maple Soopy NL NFMono CN";
        font-size = 14;
        theme = "Catppuccin Latte";
        window-decoration = "client";
        cursor-click-to-move = false;
        # async-backend = "epoll"; # see if this fixes iowait "bug"
      };
    };
  }
)

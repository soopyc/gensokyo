{
  traits,
  lib,
  ...
}:
lib.mkMerge [
  {
    programs.helix.enable = true;
  }

  (lib.mkIf traits.gui {
    programs.zed-editor = {
      enable = true;
      userSettings = {
        base_keymap = "VSCode";
        features = {
          inline_completion_provider = "none"; # no copilot
        };
        telemetry = {
          metrics = false;
        };
        vim_mode = true;
        ui_font_size = 20;
        buffer_font_size = 16;
        buffer_font_family = "Hurmit Nerd Font";
        theme = {
          mode = "system";
          light = "Catppuccin Latte";
          dark = "Catppuccin Mocha";
        };
      };
    };
  })
]

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
        # crap disablement
        assistant = {
          version = "1";
          enabled = false;
        };
        features = {
          inline_completion_provider = "none"; # no copilot
        };
        telemetry = {
          metrics = false;
        };

        # display
        ui_font_size = 20;
        buffer_font_size = 16;
        buffer_font_family = "Hurmit Nerd Font";
        preferred_line_length = 120;
        wrap_guides = [120];
        show_whitespaces = "all";
        indent_guides = {
          enabled = true;
          coloring = "indent_aware";
        };
        theme = {
          mode = "system";
          light = "Catppuccin Latte";
          dark = lib.mkForce "Catppuccin Mocha";
        };

        # editing settings
        base_keymap = "VSCode";
        hard_tabs = true;
        vim_mode = false;
        autosave = "on_focus_change";

        # nix stuff
        load_direnv = "shell_hook";

        # terminal
        terminal.env = {
          "TERM" = "xterm-256color"; # this is not set apparently
        };
      };
    };
  })
]

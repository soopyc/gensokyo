{
  traits,
  lib,
  ...
}:
lib.mkMerge [
  {
    programs.helix = {
      enable = true;
      languages.language = [
        {
          name = "yaml";
          scope = "source.yaml";
          indent = {
            unit = "  ";
            tab-width = 2;
          };
        }
      ];
    };
  }

  (lib.mkIf traits.gui {
    programs.zed-editor = {
      enable = true;
      userSettings = {
        # crap disablement
        agent = {
          version = "1";
          enabled = false;
        };
        features = {
          edit_prediction_provider = "none"; # no copilot
        };
        telemetry = {
          metrics = false;
        };

        # display
        ui_font_size = 20;
        buffer_font_size = 16;
        buffer_font_family = "Fira Code";
        buffer_font_weight = 500;
        buffer_font_features.calt = false;

        preferred_line_length = 120;
        wrap_guides = [ 120 ];
        show_whitespaces = "all";
        indent_guides = {
          enabled = true;
          coloring = "indent_aware";
        };
        theme = {
          mode = "system";
          # light = "Catppuccin Latte";
          dark = lib.mkForce "Catppuccin Mocha (pink)";
        };
        diagnostics.inline.enable = true;

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

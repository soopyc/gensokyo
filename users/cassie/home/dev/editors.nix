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
      mutableUserSettings = false;
      userSettings = {
        # crap disablement
        disable_ai = true;
        telemetry = {
          metrics = false;
        };

        # display
        ui_font_size = 20;
        buffer_font_size = 16;
        buffer_font_family = "Maple Soopy NL NFMono CN";
        buffer_font_weight = 500;
        # buffer_font_features.calt = false;

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
        diagnostics.inline.enabled = true;

        # editing settings
        base_keymap = "VSCode";
        hard_tabs = true;
        vim_mode = true;
        autosave = "on_focus_change";
        which_key.enabled = true;

        # nix stuff
        load_direnv = "shell_hook";

        # terminal
        terminal.font_family = "Maple Soopy NL NFMono CN";

        # dock crap
        project_panel.dock = "left";
        outline_panel.dock = "left";

        # language settings
        languages.Nix = {
          "tab_size" = 2;
          "hard_tabs" = false;
          "language_servers" = [
            "nixd"
            "!nil"
          ];
        };
      };
    };
  })
]

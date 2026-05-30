{ lib, config, ... }:
{
  programs.neovim.enable = !config.gensokyo.traits.gui;
  programs.nixvim = {
    enable = config.gensokyo.traits.gui;
    clipboard.providers.wl-copy.enable = true;

    # testing
    # performance.combinePlugins.enable = true;
    # extraPython3Packages = ps: with ps; [ pynvim-pp ];

    highlightOverride =
      lib.genAttrs
        [
          "LspDiagnosticUnderlineError"
          "LspDiagnosticUnderlineWarn"
          "DiagnosticUnderlineError"
          "DiagnosticUnderlineWarn"
        ]
        (
          lib.const {
            undercurl = true;
            update = true;
          }
        );

    opts = {
      number = true;
      relativenumber = true;
      tabstop = 4;

      # copied from https://github.com/helix-editor/helix/blob/1ffcd3a65d8e0d389b0a0d528bd06d14e63cfbea/helix-view/src/editor.rs#L1000
      list = true;
      listchars = "space:\\u00b7,tab:\\u2192 ,eol:\\u23ce,nbsp:\\u237d";
    };

    keymaps =
      let
        mkMap = mode: key: action: { inherit mode key action; };
        mkLuaMap = mode: key: lua: desc: {
          inherit mode key;
          options.desc = desc;
          action.__raw = lua;
        };
      in
      [
        (mkMap "n" "<Leader>t" "<cmd>Neotree<cr>")
        (mkMap "n" "U" "<C-R>")
        (mkLuaMap "n" "tb" "_M.ts_builtin.buffers" "Telescope (buffers)")
        (mkLuaMap "n" "tf" "_M.ts_builtin.find_files" "Telescope (files)")
      ];

    userCommands = {
      "Fmt" = {
        command.__raw = "function() vim.lsp.buf.format() end ";
        desc = "format the entire document";
      };
    };

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "latte";
      };
    };

    extraConfigLuaPre = ''
      _M.ts_builtin = require("telescope.builtin")
    '';

    plugins = {
      # auto-session.enable = true;
      lspconfig.enable = true;
      lualine.enable = true;
      telescope.enable = true;
      which-key.enable = true;
      gitsigns.enable = true;
      tiny-glimmer.enable = true;
      rainbow-delimeters.enable = true;
      treesitter.enable = true;
      bufferline.enable = true;

      # coq-nvim = {
      #   enable = true;
      #   installArtifacts = true;
      # };

      fidget = {
        enable = true;
        settings.notification.override_vim_notify = true;
      };

      tiny-inline-diagnostic = {
        enable = true;

        settings = {
          preset = "powerline";
          options = {
            throttle = 0;
            show_source.enabled = true;
            show_code = true;

            add_messages = {
              messages = true;
              show_multiple_glyphs = true;
            };
            multilines = {
              enabled = true;
              always_show = true;
            };
          };
        };
      };

      neo-tree = {
        enable = true;
        settings = {
          filesystem.filtered_items = {
            visible = true;
          };
        };
      };

      mini = {
        enable = true;
        mockDevIcons = true;

        modules = {
          basics = { };
          icons = { };
          # tabline = { }; # replaced by bufferline
          surround = { };
          comment = {
            mappings = {
              comment_line = "<C-c>";
              comment_visual = "<C-c>";
            };
          };
          indentscope = {
            draw = {
              delay = 0;
              animation.__raw = "function() return 0 end";
            };
          };
        };
      };
    };

    lsp = {
      inlayHints.enable = true;
      servers = {
        rust_analyzer.enable = true;
        nixd.enable = true;
        svelte.enable = true;
        astro.enable = true;
        html.enable = true;
        pyright.enable = true;
      };
    };
  };
}

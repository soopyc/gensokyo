{
  programs.nixvim = {
    enable = true;
    clipboard.providers.wl-copy.enable = true;

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
        mkMap = key: action: { inherit key action; };
      in
      [
        (mkMap "<Leader>t" "<cmd>Neotree<cr>")
        (mkMap "U" "<C-R>")
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

    plugins = {
      # auto-session.enable = true;
      coq-nvim.enable = true;
      lspconfig.enable = true;
      lualine.enable = true;
      telescope.enable = true;
      which-key.enable = true;
      gitsigns.enable = true;
      tiny-glimmer.enable = true;
      rainbow-delimeters.enable = true;
      fidget.enable = true;
      treesitter.enable = true;

      tiny-inline-diagnostic = {
        enable = true;

        settings = {
          preset = "powerline";
          options = {
            throttle = 0;
            show_source.enabled = true;
            show_code = true;

            add_messages = {
              # display_count = true;
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
          tabline = { };
          comment = {
            mappings.comment_line = "<C-c>";
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

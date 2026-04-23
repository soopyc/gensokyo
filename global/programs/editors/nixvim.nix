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

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "latte";
      };
    };

    plugins = {
      lualine.enable = true;
      neo-tree.enable = true;
      telescope.enable = true;
      which-key.enable = true;

      mini = {
        enable = true;
        mockDevIcons = true;

        modules = {
          basics = { };
          icons = { };
          indentscope = { };
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

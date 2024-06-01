{...}: {
  programs.eza = {
    enable = true;
    icons = true;
    git = true;
  };

  catppuccin = {
    enable = true;
    accent = "pink";
    flavor = "latte";
  };

  programs.zsh.enable = true;
}

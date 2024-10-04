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

  # programs.bat.enable = true;
  programs.zsh.enable = true;
}

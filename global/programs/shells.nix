{pkgs, ...}: {
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    histSize = 50000;

    # plugins
    syntaxHighlighting.enable = true;
    autosuggestions = {
      enable = true;
    };

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
  };

  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # conflicts with comma
  programs.command-not-found.enable = false;
}

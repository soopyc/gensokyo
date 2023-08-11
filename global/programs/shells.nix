{ pkgs, ... }:

{
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    histSize = 50000;

    # plugins
    syntaxHighlighting.enable = true;
    autosuggestions = {
      enable = true;
      highlightStyle = "fg=white";
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
}

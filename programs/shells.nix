{ ... }: 

{
  programs.zsh = {
    enable = true;
    histSize = 50000;

    # plugins
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      theme = "crcandy";
      plugins = [
        "git"
      ];
    };
  };
}

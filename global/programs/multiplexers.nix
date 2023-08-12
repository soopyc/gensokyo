{ pkgs, ... }: 

{
  programs.tmux = {
    enable = true;
    newSession = true;
    keyMode = "vi";
    historyLimit = 10000;

    # Rationale: being able to keep sessions open is more important than
    # security at this point, as I have a very unstable connection and
    # things may explode any minute.
    # If I manage to find a way to persist tmux sockets across logouts
    # without this I would definitely turn this back on.
    secureSocket = false;

    plugins = with pkgs.tmuxPlugins; [
      power-theme
    ];
  };
}

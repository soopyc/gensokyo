{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ gnupg pinentry ];

  programs.gnupg.agent.enable = true;
  # ideally this should be set automatically but in case that doesn't work
  #programs.gnupg.agent.pinentryFlavor = "curses"; # we don't have a gui.
}

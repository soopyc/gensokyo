{lib, ...}: {
  options.gensokyo.traits = {
    gui = lib.mkEnableOption "graphical programs, related packages and modules";

    games = lib.mkEnableOption "games and etc.";
  };
}

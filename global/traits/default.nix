{lib, ...}: {
  options.gensokyo.traits = {
    gui = lib.mkEnableOption "graphical programs, related packages and modules";
    games = lib.mkEnableOption "games and etc.";
    portable = lib.mkEnableOption ''
      modules commonly found wih portable devices.

      This includes stuff like Wifi modules and etc
    '';
  };
}

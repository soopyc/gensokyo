{lib, ...}: {
  options.gensokyo.traits = {
    sensitive = lib.mkEnableOption "or selectively disable options specific to security-sensitive systems";
    gui = lib.mkEnableOption "graphical programs, related packages and modules";
    games = lib.mkEnableOption "games and etc.";
    portable = lib.mkEnableOption ''
      modules commonly found with portable devices.

      This includes stuff like Wifi modules and etc
    '';
  };
}

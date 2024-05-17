{lib, ...}: {
  options.gensokyo.traits = {
    sensitive = lib.mkEnableOption "or selectively disable options specific to security-sensitive systems";
    secure = lib.mkEnableOption "options for a secure system like secureboot";
    gui = lib.mkEnableOption "graphical programs, related packages and modules";
    games = lib.mkEnableOption "games and etc.";
    portable = lib.mkEnableOption ''
      modules commonly found with portable devices.

      This includes stuff like Wifi modules and etc
    '';
  };
}

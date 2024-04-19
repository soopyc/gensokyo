{lib, ...}: {
  options.gensokyo.traits = {
    gui = lib.mkEnableOption "graphical programs, related packages and modules";
  };
}

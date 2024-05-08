{lib, ...}: {
  imports = [
    ./vmetrics.nix
    ./nginx.nix
  ];

  options.gensokyo.presets = {
    vmetrics = lib.mkEnableOption "vmetrics presets";
    nginx = lib.mkEnableOption "nginx presets";
  };
}
